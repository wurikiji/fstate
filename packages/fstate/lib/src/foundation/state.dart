import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

/// A key to distinguish a fstate from a fstate container.
class FstateKey {
  FstateKey(this._type, this._params);
  final Type _type;
  final List _params;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other is FstateKey && listEquals(_params, other._params));
  }

  @override
  int get hashCode => Object.hashAllUnordered(_params);

  @override
  String toString() => 'A key for $_type';
}

/// Build fstate from a selector
class DerivedFstateBuilder {
  const DerivedFstateBuilder(this.builder);
  final dynamic builder;
  call(setNextState) => builder(setNextState);
}

/// An abstract factory to create a key and a fstate
abstract class FstateFactory {
  const FstateFactory();

  /// FstateKey builder
  FstateKey get stateKey;

  /// Fstate builder
  Function get stateBuilder;

  /// Parameters to build a fstate
  List<Param> get params => [];

  /// Alternators to build a fstate
  Map<dynamic, Alternator> get alternators => {};

  /// A method to build a fstate
  Stream createStateStream(FstateStreamContainer container) {
    final subject = BehaviorSubject()
      ..addStream(
        _createStateStream(container),
      );
    return subject;
  }

  Stream _createStateStream(FstateStreamContainer container) async* {
    final manualInputs = params.where((e) => e.value is! FstateFactory);
    final deps = params.where((e) => e.value is FstateFactory);
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
      final alternator = alternators[e.key];
      return applyAlternator(e.value, alternator);
    });

    final refreshStream =
        CombineLatestStream.list(builtDeps).asyncMap((e) async {
      final derivedState =
          await _constructState([...manualInputs, ...e], (state) {
        manualSubject.add(state);
      });

      return derivedState;
    });

    BehaviorSubject mergedSubject = BehaviorSubject()
      ..addStream(
        MergeStream([refreshStream, manualSubject]).asBroadcastStream(),
      );
    yield* mergedSubject;
  }

  dynamic _constructState(
      Iterable<Param> params, void Function(dynamic) setNextState) async {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    namedParams[#$setNextState] = setNextState;
    final result =
        await Function.apply(stateBuilder, positionalParams, namedParams);
    // if the selector returns a fstate builder

    if (result is DerivedFstateBuilder) {
      // then we need to build the fstate
      return result(setNextState);
    }
    return result;
  }
}

/// A utility function to apply alternator to a stream
Stream applyAlternator(Stream source, Alternator? alternator) {
  return (alternator?.call(source) ?? source);
}
