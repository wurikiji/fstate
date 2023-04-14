// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_test.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

const inject$Counter = Finject(Counter, true);

class _$Counter implements Counter {
  _$Counter({required this.$setNextState, int a = 0, int b = 0, int c = 0})
      : _state = Counter.new(a: a, b: b, c: c);

  _$Counter.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get a => _state.a;

  @override
  int get b => _state.b;

  @override
  int get c => _state.c;

  @override
  set c(newVal) => _state.c = newVal;

  @override
  void increment() => _state.increment();

  @override
  void decrement() => _state.decrement();

  @override
  int getSum(int a, int b, int c) => _state.getSum(a, b, c);

  @override
  void incrementAction() {
    final result = _state.incrementAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
  }

  @override
  int decrementAction() {
    final result = _state.decrementAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  Future<dynamic> futureAction() {
    final result = _state.futureAction();
    return result.then((r) {
      $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
      return r;
    });
  }

  @override
  dynamic asyncAction() {
    final result = _state.asyncAction();
    return result.then((r) {
      $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
      return r;
    });
  }

  @override
  Stream<dynamic> streamAction() {
    final result = _state.streamAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  dynamic asyncStreamAction() {
    final result = _state.asyncStreamAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  Counter incrementActionReturnsNextState() {
    final result = _state.incrementActionReturnsNextState();
    final nextState = _$Counter.from(result, $setNextState: $setNextState);
    $setNextState(nextState);
    return nextState;
  }

  @override
  Future<Counter> futureEmitter() {
    final result = _state.futureEmitter();
    return result.then((r) {
      final nextState = _$Counter.from(r, $setNextState: $setNextState);
      $setNextState(nextState);
      return nextState;
    });
  }
}

class $Counter extends FstateFactory {
  $Counter({this.a = 0, this.b = 0, this.c = 0})
      : $stateKey = FstateKey('Counter', [Counter.new, a, b, c]);

  final int a;
  final int b;
  final int c;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params =>
      [Param.named(#a, a), Param.named(#b, b), Param.named(#c, c)];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

extension CounterToFstateExtension on Counter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Counter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}
