import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

int constantInjection() => 42;

int constantFromContainer() => 42;

const mock = FstateKey(builder: constantInjection);

@fstate
class PositionalInjection {
  @constructor
  const PositionalInjection(
    @Inject(from: constantInjection) this.value,
    @Inject(from: constantFromContainer) int withContainer,
    @Inject(from: mock) int? mockValue,
  );

  final int value;
}

// To be
const $positionalInjection = _PositionalInjectionKey(
  builder: PositionalInjection.new,
);

class _PositionalInjectionKey extends FstateKey<PositionalInjection> {
  const _PositionalInjectionKey({required super.builder});
  @override
  List<PositionalParam> get additionalPositionalInputs => [
        PositionalParam(index: 0, value: constantInjection),
        PositionalParam(index: 1, value: constantFromContainer),
        PositionalParam(index: 2, value: mock),
      ];
}

@fstate
class NamedInjection {
  @constructor
  const NamedInjection({
    @Inject(from: constantInjection) required this.value,
    @Inject() required PositionalInjection testing,
    @Inject(from: constantFromContainer) required int withContainer,
  });

  final int value;
}

// To be
final $namedInjection = _NamedInjectionKey(
  builder: NamedInjection.new,
);

class _NamedInjectionKey extends FstateKey<NamedInjection> {
  _NamedInjectionKey({required super.builder});

  @override
  Map<Symbol, dynamic> get additionalNamedInputs => {
        #value: constantInjection,
        #withContainer: constantFromContainer,
        #testing: $positionalInjection,
      };
}

void main() {
  late FstateContainer container;
  setUp(() => container = FstateContainer());

  test('Automatically inject from functions', () {
    final PositionalInjection positionalInjection =
        $positionalInjection.build(container);
    expect(positionalInjection.value, 42);
    container.put($positionalInjection, positionalInjection);

    final NamedInjection namedInjection = $namedInjection.build(container);
    expect(namedInjection.value, 42);
  });
}
