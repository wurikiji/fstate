// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// StateGenerator
// **************************************************************************

const inject$BBBB = Finject(BBBB, true);

class _$BBBB implements BBBB {
  _$BBBB({required this.$setNextState, required Counter counter})
      : _state = BBBB.have(counter);

  _$BBBB.from(
    this._state, {
    required this.$setNextState,
  });

  final void Function(BBBB) $setNextState;
  final BBBB _state;
}

class $BBBB extends FstateFactory {
  $BBBB(this.counter) : $stateKey = FstateKey('BBBB', [BBBB.have, counter]);

  final Counter? counter;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$BBBB.new;

  @override
  List<Param> get $params => [Param.named(#counter, counter ?? Counter())];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}

extension BBBBToFstateExtension on BBBB {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$BBBB.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  }
}
