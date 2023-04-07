import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/helpers/state_generator.dart';
import 'package:test/test.dart';

import '../dart_format_extension.dart';

void main() {
  group('Extended State Generator', () {
    final actions = [
      FstateAction.field(
        name: 'count',
        returnType: 'int',
      ),
      FstateAction.setter(
        name: 'value',
        returnType: 'String',
      ),
      FstateAction.method(
        name: 'increment',
        returnType: 'void',
      ),
      FstateAction.method(
        name: 'multiply',
        returnType: 'int',
        params: [
          ParameterWithMetadata.positional(
            name: 'value',
            type: 'int',
            position: 0,
            autoInject: false,
          ),
        ],
      ),
      FstateAction.method(
        name: 'divide',
        returnType: 'double',
        params: [
          ParameterWithMetadata.positional(
            name: 'value',
            type: 'int',
            defaultValue: '0',
            position: 0,
            autoInject: false,
          ),
        ],
      ),
      FstateAction.emitter(
        name: 'decrement',
        returnType: 'Counter',
      ),
    ];
    test('can generate actions', () async {
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

      for (var i = 0; i < actions.length; i++) {
        expect(actions[i].generate('_Count').format(), expected[i].format());
      }
    });
    test('can generate an extended state', () async {
      final targets = [
        ExtendedStateGenerator(
          baseName: 'Counter',
          constructorParams: <ParameterWithMetadata>[],
        ),
        ExtendedStateGenerator(
          baseName: 'Counter',
          constructor: 'Counter.new',
          constructorParams: <ParameterWithMetadata>[],
        ),
        ExtendedStateGenerator(
          baseName: 'Counter',
          constructor: 'Counter.new',
          constructorParams: <ParameterWithMetadata>[
            ParameterWithMetadata.positional(
              name: 'value',
              type: 'int',
              defaultValue: '0',
              position: 0,
              autoInject: false,
            ),
          ],
        ),
        ExtendedStateGenerator(
          baseName: 'Counter',
          constructor: 'Counter',
          constructorParams: <ParameterWithMetadata>[],
          actions: actions,
        ),
      ];
      final expected = [
        r'''
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
}
''',
        r'''
class _Counter implements Counter {
  _Counter({
    required this.$setNextState,
  }) : _state = Counter.new();

  _Counter.from({
    required this.$setNextState,
    required Counter $state,
  }) : _state = $state;

  final void Function(Counter) $setNextState;
  final Counter _state;
}
''',
        r'''
class _Counter implements Counter {
  _Counter({
    required this.$setNextState,
    int value = 0
    }) : _state = Counter.new(value,);

  _Counter.from({
    required this.$setNextState,
    required Counter $state,
  }) : _state = $state;

  final void Function(Counter) $setNextState;
  final Counter _state;
}
''',
        r'''
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

            @override int get count => _state.count; 
        @override
        set count(int $value) {
          _state.count = $value; 
          $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
        }
        
        @override
        set value(String $value) {
          _state.value = $value; 
          $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
        }
        
@override
void increment() {
  final $result = _state.increment(); 
  $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
}
        
@override
int multiply(int value,) {
  final $result = _state.multiply(value,); 
  $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
  return $result;
}
        
@override
double divide([int value = 0]) {
  final $result = _state.divide(value,); 
  $setNextState(_Counter.from($state: _state, $setNextState: $setNextState));
  return $result;
}

        
@override
Counter decrement() {
  final $result = _state.decrement();
  final $nextState = _Counter.from($state: $result, $setNextState: $setNextState);
  $setNextState($nextState);
  return $nextState;
}
  
}
''',
      ];

      for (var i = 0; i < targets.length; i++) {
        expect(targets[i].toString().format(), expected[i].format());
      }
    });
  });
}
