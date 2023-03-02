import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

// part 'injection_test.g.dart';

int constantInjection() => 42;

@fstate
class PositionalInjection {
  @constructor
  const PositionalInjection(
    @Inject(from: constantInjection) this.value,
  );

  final int value;
}

const $positionalInjection = _PositionalInjectionKey(
  builder: PositionalInjection.new,
);

class _PositionalInjectionKey extends FstateKey<PositionalInjection> {
  const _PositionalInjectionKey({required super.builder});
  @override
  List<PositionalParam> buildAdditionalPositionalInputs(
      FstateContainer container) {
    final int value = constantInjection();
    return [PositionalParam(index: 0, value: value)];
  }
}

@fstate
class NamedInjection {
  @constructor
  const NamedInjection({
    @Inject(from: constantInjection) required this.value,
    @Inject() PositionalInjection? testing,
  });

  final int value;
}

final $namedInjection = _NamedInjectionKey(
  builder: NamedInjection.new,
);

class _NamedInjectionKey extends FstateKey<NamedInjection> {
  _NamedInjectionKey({required super.builder});
  @override
  Map<Symbol, dynamic> buildAdditionalNamedInputs(FstateContainer container) {
    @override
    final int value = constantInjection();
    return {#value: value};
  }
}

void main() {
  late FstateContainer container;
  setUp(() => container = FstateContainer());

  test('Automatically inject from functions', () {
    final PositionalInjection positionalInjection =
        $positionalInjection.build(container);
    expect(positionalInjection.value, 42);
    final NamedInjection namedInjection = $namedInjection.build(container);
    expect(namedInjection.value, 42);
  });
}
