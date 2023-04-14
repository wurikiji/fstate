// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

const inject$Counter$ = Finject(Counter, false);

class _$Counter implements Counter {
  _$Counter({required this.$setNextState, required int count})
      : _state = Counter.new(count);

  _$Counter.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get count => _state.count;

  @override
  set count(newVal) => _state.count = newVal;

  @override
  void increment() {
    final result = _state.increment();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
  }

  @override
  void decrement() {
    final result = _state.decrement();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
  }
}

class $Counter extends FstateFactory {
  $Counter(this.count) : $stateKey = FstateKey('Counter', [Counter.new, count]);

  final int count;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [Param.named(#count, count)];

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
