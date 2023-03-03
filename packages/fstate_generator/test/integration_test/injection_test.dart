import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

part 'injection_test.g.dart';

int constantInjection() => 42;

@fstate
class PositionalInjection {
  @constructor
  const PositionalInjection(
    @Inject(from: constantInjection) this.value,
  );

  final int value;
}

@fstate
class NamedInjection {
  @constructor
  const NamedInjection({
    @Inject(from: constantInjection) required this.value,
    @Inject() required PositionalInjection testing,
  });

  final int value;
}

void main() {
  late FstateContainer container;
  setUp(() => container = FstateContainer());

  test('Automatically inject ', () {
    final PositionalInjection positionalInjection =
        $positionalInjection.build(container);
    expect(positionalInjection.value, 42);
    container.put($positionalInjection, positionalInjection);

    final NamedInjection namedInjection = $namedInjection.build(container);
    expect(namedInjection.value, 42);
  });
}
