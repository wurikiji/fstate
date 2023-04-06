import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/helpers/state_generator.dart';
import 'package:test/test.dart';

import '../dart_format_extension.dart';

void main() {
  group('Extended State Generator', () {
    test('can generate actions', () async {
      final targets = [
        StateAction.field(
          name: 'count',
          returnType: 'int',
        ).generate('_Count'),
        StateAction.setter(
          name: 'value',
          returnType: 'String',
        ).generate('_Count'),
        StateAction.method(
          name: 'increment',
          returnType: 'void',
        ).generate('_Count'),
        StateAction.method(
          name: 'multiply',
          returnType: 'int',
          params: [
            ParameterWithMetadata.positional(
              parameter: Parameter(
                name: 'value',
                type: 'int',
              ),
              position: 0,
            ),
          ],
        ).generate('_Count'),
        StateAction.method(
          name: 'divide',
          returnType: 'double',
          params: [
            ParameterWithMetadata.positional(
              parameter: Parameter(
                name: 'value',
                type: 'int',
                defaultValue: '0',
              ),
              position: 0,
            ),
          ],
        ).generate('_Count'),
        StateAction.emitter(
          name: 'decrement',
          returnType: 'Counter',
        ).generate('_Count'),
      ];
      final expected = [
        r'''@override int get count => _state.count; 
        @override
        set count(int $value) {
          _state.count = $value; 
          $setNextState(_Count.from($state: _state, $setNextState: $setNextState));
        }''',
        r'''
        @override
        set value(String $value) {
          _state.value = $value; 
          $setNextState(_Count.from($state: _state, $setNextState: $setNextState));
        }''',
        r'''
@override
void increment() {
  final $result = _state.increment(); 
  $setNextState(_Count.from($state: _state, $setNextState: $setNextState));
}''',
        r'''
@override
int multiply(int value,) {
  final $result = _state.multiply(value,); 
  $setNextState(_Count.from($state: _state, $setNextState: $setNextState));
  return $result;
}''',
        r'''
@override
double divide([int value = 0]) {
  final $result = _state.divide(value,); 
  $setNextState(_Count.from($state: _state, $setNextState: $setNextState));
  return $result;
}
''',
        r'''
@override
Counter decrement() {
  final $result = _state.decrement();
  final $nextState = _Count.from($state: $result, $setNextState: $setNextState);
  $setNextState($nextState);
  return $nextState;
}
''',
      ];

      for (var i = 0; i < targets.length; i++) {
        expect(targets[i].format(), expected[i].format());
      }
    });
    test('can generate an extended state', () async {
      final target = ExtendedStateGenerator(
        name: 'Counter',
        constructor: 'new',
        constructorParams: <ParameterWithMetadata>[],
        actions: [
          StateAction.field(
            name: 'count',
            returnType: 'int',
          ),
          StateAction.setter(
            name: 'value',
            returnType: 'String',
          ),
          StateAction.method(
            name: 'increment',
            returnType: 'void',
          ),
          StateAction.method(
            name: 'increment2',
            returnType: 'int',
            params: [
              ParameterWithMetadata.positional(
                parameter: Parameter(
                  name: 'value',
                  type: 'int',
                ),
                position: 0,
              ),
            ],
          ),
          StateAction.emitter(
            name: 'decrement',
            returnType: 'Counter',
          ),
        ],
      );
    });
  });
}
