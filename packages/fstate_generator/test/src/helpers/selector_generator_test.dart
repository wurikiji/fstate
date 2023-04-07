import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/helpers/selector_generator.dart';
import 'package:test/test.dart';

import '../dart_format_extension.dart';

void main() {
  group('Selector generator', () {
    final targets = [
      ExtendedSelectorGenerator(
        returnType: 'int',
        name: 'countSelector',
        params: [
          ParameterWithMetadata.positional(
            type: 'Counter',
            name: 'counter',
            position: 0,
            autoInject: true,
          ),
        ],
      ),
      ExtendedSelectorGenerator(
        returnType: 'int',
        name: 'countSelector',
        params: [
          ParameterWithMetadata.named(
            type: 'Counter',
            name: 'counter',
            autoInject: true,
          ),
        ],
      ),
      ExtendedSelectorGenerator(
        returnType: 'int',
        name: 'countSelector',
        params: [
          ParameterWithMetadata.positional(
            type: 'Counter',
            name: 'counter',
            position: 0,
            autoInject: true,
          ),
          ParameterWithMetadata.named(
            type: 'int',
            name: 'salt',
            defaultValue: '10',
            autoInject: true,
          ),
        ],
      )
    ];
    test('can generate wrapped selector', () {
      final expected = [
        'int _countSelector({setNextState, required Counter counter}) => countSelector(counter,);',
        'int _countSelector({setNextState, required Counter counter}) => countSelector(counter: counter);',
        'int _countSelector({setNextState, required Counter counter, int salt = 10}) => countSelector(counter, salt: salt);',
      ];
      for (var i = 0; i < targets.length; i++) {
        final target = targets[i];
        final actual = target.toString();
        expect(actual.format(), expected[i].format());
      }
    });
  });
}
