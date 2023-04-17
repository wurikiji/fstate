import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

/// A key to distinguish a fstate from a fstate container.
class FstateKey {
  /// TODO: What if _params contains closures?
  FstateKey(this._type, this._params);
  final String _type;
  final List _params;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other is FstateKey && listEquals(_params, other._params));
  }

  @override
  int get hashCode => Object.hashAllUnordered(_params);

  @override
  String toString() => 'A key for $_type with parameters: $_params';
}

/// Build fstate from a selector
class DerivedFstateBuilder {
  const DerivedFstateBuilder(this.builder);
  final dynamic builder;

  /// Build a fstate
  $buildFstate(setNextState) => builder(setNextState);
}

/// An abstract factory to create a key and a fstate
abstract class FstateFactory {
  FstateFactory();

  /// FstateKey builder
  FstateKey get $stateKey;

  /// Fstate builder
  Function get $stateBuilder;

  /// Parameters to build a fstate
  List<Param> get $params => [];

  /// Alternators to build a fstate
  Map<dynamic, FTransformer> get $transformers => {};

  /// Whether to keep the fstate alive
  bool get $keepAlive => false;

  bool _needUnregister = false;

  /// A method to build a fstate
  BehaviorSubject createStateStream(FstateStreamContainer container) {
    final subject = BehaviorSubject()
      ..addStream(
        _createStateStream(container).distinctUnique(),
      );
    return subject;
  }

  void unregister(FstateStreamContainer container) {
    container.unregister($stateKey);
    if (!container.contains($stateKey)) {
      _unregisterDepdencies(container);
    }
  }

  void _unregisterDepdencies(FstateStreamContainer container) {
    if (!_needUnregister) {
      return;
    }
    final deps = $params
        .where((e) => e.value is FstateFactory)
        .map((e) => e.value as FstateFactory);
    for (final dep in deps) {
      dep.unregister(container);
    }
    _needUnregister = false;
  }

  Stream _createStateStream(FstateStreamContainer container) async* {
    final manualInputs = $params.where((e) => e.value is! FstateFactory);
    final deps = $params.where((e) => e.value is FstateFactory);
    final manualSubject = BehaviorSubject();

    if (deps.isEmpty) {
      final firstState = await _constructState(manualInputs, (state) {
        manualSubject.add(state);
      });

      yield* manualSubject..add(firstState);
      return;
    }

    final builtDeps = deps
        .map((e) => calculateFstateFactoryParam(
              container,
              e,
              <V>(key, V value) {
                return (e is NamedParam)
                    ? Param.named(key, value)
                    : Param.positional(key, value);
              },
            ))
        .map((e) {
      final transformer = $transformers[e.key];
      return applyTransformer(e.value, transformer);
    });
    _unregisterDepdencies(container);
    _needUnregister = true;

    final refreshStream =
        CombineLatestStream.list(builtDeps).asyncMap((e) async {
      final derivedState =
          await _constructState([...manualInputs, ...e], (state) {
        manualSubject.add(state);
      });

      return derivedState;
    });

    yield* MergeStream([refreshStream, manualSubject]);
  }

  dynamic _constructState(
      Iterable<Param> params, void Function(dynamic) setNextState) async {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    namedParams[#$setNextState] = setNextState;
    final result =
        await Function.apply($stateBuilder, positionalParams, namedParams);
    // if the selector returns a fstate builder
    try {
      return result.$buildFstate(setNextState);
    } catch (e) {
      return result;
    }
  }

  @override
  bool operator ==(Object? other) {
    // Key is the source of truth
    return identical(this, other) ||
        (other is FstateFactory && $stateKey == other.$stateKey);
  }

  @override
  int get hashCode => Object.hashAllUnordered([$stateKey]);

  @override
  String toString() => 'A factory for ${$stateKey}';
}

/// A utility function to apply transformer to a stream
Stream applyTransformer(Stream source, FTransformer? transformer) {
  return (transformer?.call(source) ?? source);
}
