import 'package:fstate_generator/src/helpers/factory_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:test/test.dart';

import '../dart_format_extension.dart';

void main() {
  group('Factory generator', () {
    test('can generate param list', () {
      String wrap(String s) => 'final a = [$s];';
      for (int i = 0; i < params.length; i++) {
        final actual = params[i].toFstateFactoryParam();
        expect(
          wrap(actual).format(),
          wrap(paramsExpected[i]).format(),
        );
      }
    });
    test('can generate factory', () {
      for (int i = 0; i < factoryGenerators.length; i++) {
        final actual = factoryGenerators[i].toString();
        expect(actual.format(), factoryGeneratorExpected[i].format());
      }
    });
  });
}

final params = [
  ParameterWithMetadata.positional(
    name: 'value',
    type: 'int',
    defaultValue: '0',
    position: 0,
  ),
  ParameterWithMetadata.positional(
    name: 'value2',
    type: 'int',
    position: 0,
  ),
  ParameterWithMetadata.named(
    name: 'name',
    type: 'String',
  ),
  ParameterWithMetadata.named(
    name: 'counter',
    type: 'Counter',
    defaultValue: r'$Counter()',
  ),
];
final paramsExpected = [
  'Param.named(#value, 0)',
  'Param.named(#value2, value2)',
  'Param.named(#name, name)',
  'Param.named(#counter, \$Counter())',
];

final factoryGenerators = [
  FstateFactoryGenerator(
    baseName: 'Counter',
    type: 'Counter',
    params: params,
    stateConstructor: '_Counter.new',
    alternators: [
      AlternatorArg(
        target: 'counter',
        name: 'debounceOneSecond',
      ),
    ],
  ),
];
final factoryGeneratorExpected = [
  r'''
class $Counter extends FstateFactory<Counter> {
  $Counter({
    required int value2,
    required String name
  }
  ): stateKey = _CounterKey(value2: value2, name: name);

  @override
  final FstateKey stateKey;

  @override
  Function get stateBuilder => _Counter.new;

  @override
  List<Param> get params => [
      Param.named(#value, 0),
      Param.named(#value2, value2),
      Param.named(#name, name),
      Param.named(#counter, $Counter())
  ];

  @override
  Map<dynamic, Alternator> get alternators => {
    #counter: debounceOneSecond
  };
}
'''
];
