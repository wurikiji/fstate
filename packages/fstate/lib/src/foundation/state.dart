import 'dart:async';

import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/equality.dart';

class FstateKey {
  FstateKey(this._type, this._params);
  final Type _type;
  final List _params;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other is FstateKey && areTwoListsSame(_params, other._params));
  }

  @override
  int get hashCode => Object.hashAllUnordered(_params);

  @override
  String toString() => 'A key for $_type';
}

abstract class FstateFactory {
  const FstateFactory();

  FstateKey get stateKey;
  Function get stateBuilder;

  List<Param> get params => [];
  Map<dynamic, Alternator> get alternators => {};

  Stream createStateStream(FstateStreamContainer container) {
    final manualInputs = params.where((e) => e.value is! FstateFactory);
    final deps = params.where((e) => e.value is FstateFactory);
    final manualSubject = BehaviorSubject();

    if (deps.isEmpty) {
      final firstState = _constructState(manualInputs, (state) {
        manualSubject.add(state);
      });

      if (firstState is Future) {
        firstState.then((value) => manualSubject..add(value));
        return manualSubject;
      }
      return manualSubject..add(firstState);
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
      final derivedState = _constructState([...manualInputs, ...e], (state) {
        manualSubject.add(state);
      });
      if (derivedState is Future) {
        // ignore: await_only_futures, unnecessary_cast
        return await (derivedState as Future);
      }

      return derivedState;
    });

    BehaviorSubject mergedSubject = BehaviorSubject()
      ..addStream(
        MergeStream([refreshStream, manualSubject]).asBroadcastStream(),
      );
    return mergedSubject;
  }

  dynamic _constructState(
      Iterable<Param> params, void Function(dynamic) setNextState) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    namedParams[#$setNextState] = setNextState;
    return Function.apply(stateBuilder, positionalParams, namedParams);
  }
}

Stream applyAlternator(Stream source, Alternator? alternator) {
  return (alternator?.call(source) ?? source);
}
