import 'package:fstate_generator/src/helpers/key_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';

class FstateFactoryGenerator {
  FstateFactoryGenerator({
    required this.baseName,
    required this.type,
    this.params = const [],
    this.stateConstructor = '',
    this.alternators = const [],
  });

  final String baseName;
  final String type;
  final String stateConstructor;
  final List<ParameterWithMetadata> params;
  final List<AlternatorArg> alternators;

  @override
  String toString() {
    final familyParams =
        params.where((element) => element.defaultValue == null);
    final constructorParams = joinParamsToNamedParams(familyParams);
    return '''
class \$$baseName extends FstateFactory<$type> {
  \$$baseName(
    ${constructorParams.isNotEmpty ? '{$constructorParams}' : ''}
) : stateKey = ${baseName.toKeyName()}(${joinParamsToNamedArguments(familyParams)});

  @override
  final FstateKey stateKey;

  @override
  Function get stateBuilder => $stateConstructor;

  @override
  List<Param> get params => [
    ${joinParamsToFstateFactoryParams(params)}
  ];

  @override
  Map<dynamic, Alternator> get alternators => {
    ${joinAlternatorsToMap(alternators)}
  };
}
''';
  }
}

String joinParamsToFstateFactoryParams(List<ParameterWithMetadata> params) {
  return params.map((e) => e.toFstateFactoryParam()).join(',\n');
}

String joinAlternatorsToMap(List<AlternatorArg> alternators) {
  return alternators
      .map((e) => '#${e.target}: ${e.alternatorName}')
      .join(',\n');
}

class AlternatorArg {
  AlternatorArg({
    required this.target,
    required this.alternatorName,
  });
  final String target;
  final String alternatorName;
}
