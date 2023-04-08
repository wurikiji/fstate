import 'package:fstate_generator/src/helpers/field.dart';

import 'parameter.dart';

class ExtendedStateGenerator {
  ExtendedStateGenerator({
    required this.baseName,
    this.actions = const [],
    String? constructor,
    this.constructorParams = const [],
    this.fields = const [],
  })  : constructor = constructor ?? baseName,
        assert(baseName.isNotEmpty, 'name should not be empty');

  final String baseName;
  final String constructor;
  final List<ParameterWithMetadata> constructorParams;
  final List<FstateAction> actions;
  final List<FstateField> fields;

  @override
  String toString() {
    final stateActions = actions.map((e) => e.generate('_$baseName')).join();
    final overrideFields = fields.map((e) => e.proxyFieldTo('_state')).join();
    return '''
extension \$TodoStoreToFstate on $baseName {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      (\$setNextState) => _$baseName.from(
        \$state: this,
        \$setNextState: \$setNextState,
      ),
    );
  }
}

class _$baseName implements $baseName {
  _$baseName({
    required this.\$setNextState,
    ${joinParamsToNamedParams(constructorParams)}
  }) : _state = $constructor(${joinParamsWithMetadataToArguments(constructorParams)});

  _$baseName.from({
    required this.\$setNextState,
    required $baseName \$state,
  }) : _state = \$state;

  final void Function($baseName) \$setNextState;
  final $baseName _state;

  $overrideFields

  $stateActions
}
''';
  }
}

abstract class FstateAction {
  FstateAction({
    required this.name,
    required this.returnType,
    this.params = const [],
  })  : assert(name.isNotEmpty, 'name should not be empty'),
        assert(returnType.isNotEmpty, 'returnType should not be empty');

  factory FstateAction.field({
    required String name,
    required String returnType,
  }) =>
      FieldStateAction(
        name: name,
        returnType: returnType,
      );

  factory FstateAction.setter({
    required String name,
    required String returnType,
  }) =>
      SetterStateAction(
        name: name,
        returnType: returnType,
      );

  factory FstateAction.method({
    required String name,
    required String returnType,
    List<ParameterWithMetadata> params = const [],
  }) =>
      MethodStateAction(
        name: name,
        returnType: returnType,
        params: params,
      );

  factory FstateAction.emitter({
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

class FieldStateAction extends FstateAction {
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

class SetterStateAction extends FstateAction {
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

class MethodStateAction extends FstateAction {
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
  ${returnType.isFuture ? '\$result.then((_) => \$setNextState($stateName.from(\$state: _state, \$setNextState: \$setNextState)));' : '\$setNextState($stateName.from(\$state: _state, \$setNextState: \$setNextState));'}
  ${returnType == 'void' ? '' : 'return \$result;'}
}
''';
  }
}

class EmitterStateAction extends FstateAction {
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
  ${returnType.isFuture ? '''
final nextState = \$result.then((v) {
  return $stateName.from(\$state: v, \$setNextState: \$setNextState);
  });
  nextState.then((v) => \$setNextState(v));
''' : '''
final nextState = $stateName.from(\$state: \$result, \$setNextState: \$setNextState);
\$setNextState(nextState);
'''}
  return nextState;
}
''';
  }
}

extension IsFuture on String {
  bool get isFuture => startsWith('Future') && !contains(' ');
}
