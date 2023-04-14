// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'derived_counter_test.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

const inject$DerivedCounter = Finject(DerivedCounter, true);

class _$DerivedCounter implements DerivedCounter {
  _$DerivedCounter(
      {required this.$setNextState, required Counter counter, int a = 0})
      : _state = DerivedCounter.new(counter, a: a);

  _$DerivedCounter.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(DerivedCounter) $setNextState;
  final DerivedCounter _state;
}

class $DerivedCounter extends FstateFactory {
  $DerivedCounter(this.counter, {this.a = 0})
      : $stateKey =
            FstateKey('DerivedCounter', [DerivedCounter.new, counter, a]);

  final Counter? counter;
  final int a;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$DerivedCounter.new;

  @override
  List<Param> get $params =>
      [Param.named(#counter, counter ?? Counter()), Param.named(#a, a)];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

extension DerivedCounterToFstateExtension on DerivedCounter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$DerivedCounter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}
