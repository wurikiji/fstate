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

abstract class FstateFactory<T> {
  const FstateFactory();

  FstateKey get stateKey;
  Function get stateBuilder;

  List<Param> get params => [];
  Map<dynamic, Alternator> get alternators => {};

  Stream<T> createStateStream(FstateStreamContainer container) {
    final manualInputs = params.where((e) => e.value is! FstateFactory);
    final deps = params.where((e) => e.value is FstateFactory);
    final manualSubject = BehaviorSubject<T>();

    if (deps.isEmpty) {
      final firstState = _constructState(manualInputs, (state) {
        manualSubject.add(state);
      });

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

    final refreshStream = CombineLatestStream.list(builtDeps).map<T>((e) {
      return _constructState([...manualInputs, ...e], (T state) {
        manualSubject.add(state);
      });
    });

    return MergeStream([refreshStream, manualSubject]).asBroadcastStream();
  }

  T _constructState(Iterable<Param> params, void Function(T) setNextState) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    namedParams[#$setNextState] = setNextState;
    return Function.apply(stateBuilder, positionalParams, namedParams);
  }
}

Stream applyAlternator(Stream source, Alternator? alternator) {
  return (alternator?.call(source) ?? source);
}
