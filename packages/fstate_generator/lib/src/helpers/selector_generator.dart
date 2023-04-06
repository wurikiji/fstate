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
  ${joinParamsToNamedParams(params.map((e) => e.parameter))}
})
''';
  }

  String _generateCall() {
    return '$name(${joinParamsWithMetadataToArguments(params)})';
  }
}
