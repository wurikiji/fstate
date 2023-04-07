import 'parameter.dart';

class ExtendedStateGenerator {
  ExtendedStateGenerator({
    required this.name,
    this.actions = const [],
    this.constructor = 'new',
    this.constructorParams = const [],
  }) : assert(name.isNotEmpty, 'name should not be empty');

  final String name;
  final String constructor;
  final List<ParameterWithMetadata> constructorParams;
  final List<StateAction> actions;

  String generate() {
    final stateActions = actions.map((e) => e.generate('_$name')).join();
    return '''
class _$name implements $name {
  _$name({
    required this.\$setNextState,
    ${joinParamsToNamedParams(constructorParams)}
  }) : _state = $name.$constructor(${joinParamsWithMetadataToArguments(constructorParams)});

  _$name.from({
    required this.\$setNextState,
    required $name \$state,
  }) : _state = \$state;

  final void Function($name) \$setNextState;
  final $name _state;

  $stateActions
}
''';
  }
}

abstract class StateAction {
  StateAction({
    required this.name,
    required this.returnType,
    this.params = const [],
  })  : assert(name.isNotEmpty, 'name should not be empty'),
        assert(returnType.isNotEmpty, 'returnType should not be empty');

  factory StateAction.field({
    required String name,
    required String returnType,
  }) =>
      FieldStateAction(
        name: name,
        returnType: returnType,
      );

  factory StateAction.setter({
    required String name,
    required String returnType,
  }) =>
      SetterStateAction(
        name: name,
        returnType: returnType,
      );

  factory StateAction.method({
    required String name,
    required String returnType,
    List<ParameterWithMetadata> params = const [],
  }) =>
      MethodStateAction(
        name: name,
        returnType: returnType,
        params: params,
      );

  factory StateAction.emitter({
    required String name,
    required String returnType,
    List<ParameterWithMetadata> params = const [],
  }) =>
      EmitterStateAction(
        name: name,
        returnType: returnType,
        params: params,
      );

  final String name;
  final String returnType;
  final List<ParameterWithMetadata> params;

  String generate(String stateName);
}

class FieldStateAction extends StateAction {
  FieldStateAction({
    required String name,
    required String returnType,
  }) : super(
          name: name,
          returnType: returnType,
        );

  @override
  String generate(String stateName) {
    final setter = SetterStateAction(name: name, returnType: returnType)
        .generate(stateName);
    return '''
@override
$returnType get $name => _state.$name;
$setter
''';
  }
}

class SetterStateAction extends StateAction {
  SetterStateAction({
    required String name,
    required String returnType,
  }) : super(
          name: name,
          returnType: returnType,
        );

  @override
  String generate(String stateName) {
    return '''
@override
set $name($returnType \$value) {
  _state.$name = \$value;
  \$setNextState($stateName.from(\$state: _state, \$setNextState: \$setNextState));
}
''';
  }
}

class MethodStateAction extends StateAction {
  MethodStateAction({
    required String name,
    required String returnType,
    List<ParameterWithMetadata> params = const [],
  }) : super(
          name: name,
          returnType: returnType,
          params: params,
        );

  @override
  String generate(String stateName) {
    return '''
@override
$returnType $name(${joinParamsWithMetadata(params)}) {
  final \$result = _state.$name(${joinParamsWithMetadataToArguments(params)});
  \$setNextState($stateName.from(\$state: _state, \$setNextState: \$setNextState));
  ${returnType == 'void' ? '' : 'return \$result;'}
}
''';
  }
}

class EmitterStateAction extends StateAction {
  EmitterStateAction({
    required String name,
    required String returnType,
    List<ParameterWithMetadata> params = const [],
  }) : super(
          name: name,
          returnType: returnType,
          params: params,
        );

  @override
  String generate(String stateName) {
    return '''
@override
$returnType $name(${joinParamsWithMetadata(params)}) {
  final \$result = _state.$name(${joinParamsWithMetadataToArguments(params)});
  final \$nextState = $stateName.from(\$state: \$result, \$setNextState: \$setNextState);
  \$setNextState(\$nextState);
  return \$nextState;
}
''';
  }
}
