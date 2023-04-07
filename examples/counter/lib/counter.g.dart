// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

class _CounterKey extends FstateKey {
  _CounterKey({Function $constructor = Counter.new})
      : super(Counter, [$constructor]);
}

class _Counter implements Counter {
  _Counter({
    required this.$setNextState,
  }) : _state = Counter();

  _Counter.from({
    required this.$setNextState,
    required Counter $state,
  }) : _state = $state;

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get count => _state.count;
  @override
  set count(int $value) {
    _state.count = $value;
    $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
  }
}

class $Counter extends FstateFactory {
  $Counter() : stateKey = _CounterKey();

  @override
  final FstateKey stateKey;

  @override
  Function get stateBuilder => _Counter.new;

  @override
  List<Param> get params => [];

  @override
  Map<dynamic, Alternator> get alternators => {};
}
