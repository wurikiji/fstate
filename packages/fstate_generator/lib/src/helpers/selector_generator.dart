import 'package:fstate_generator/src/helpers/parameter.dart';

class ExtendedSelectorGenerator {
  ExtendedSelectorGenerator({
    required this.returnType,
    required this.name,
    required this.params,
  })  : assert(name.isNotEmpty, 'name should not be empty'),
        assert(returnType.isNotEmpty, 'returnType should not be empty');

  final String returnType;
  final String name;
  final List<ParameterWithMetadata> params;

  @override
  String toString() {
    return '${_generateDefinition()} => ${_generateCall()};';
  }

  String _generateDefinition() {
    return '''
$returnType _$name({
  setNextState,
  ${_paramsToNamedParams()}
})
''';
  }

  String _generateCall() {
    return '$name(${_paramsToArguments()})';
  }

  String _paramsToNamedParams() {
    return params
        .map((e) =>
            '${e.isRequired && e.parameter.defaultValue == null ? 'required' : ''} ${e.parameter.type} ${e.parameter.name} ${e.parameter.defaultValue != null ? '= ${e.parameter.defaultValue}' : ''}')
        .join(',');
  }

  String _paramsToArguments() {
    final positionals = params
        .where((e) => e.isPositional)
        .map((e) => e.parameter.name)
        .join(',');
    final named = params
        .where((e) => e.isNamed)
        .map((e) => '${e.parameter.name}: ${e.parameter.name}')
        .join(',');
    return '''
  ${positionals.isNotEmpty ? '$positionals,' : ''}
  $named
''';
  }
}
