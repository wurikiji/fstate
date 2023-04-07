import 'package:fstate_generator/src/helpers/key_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:recase/recase.dart';

import 'alternator.dart';

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
    final familyParams = params.where(
      (element) => element.defaultValue == null && !element.autoInject,
    );
    final constructorParams = joinParamsToNamedParams(familyParams);
    final factoryName = '\$${baseName.pascalCase}';
    return '''
class $factoryName extends FstateFactory {
  $factoryName(
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

extension ToFstateFactoryParam on Parameter {
  String toFstateFactoryParam() {
    final value = autoInject ? '\$$type()' : defaultValue ?? name;
    return 'Param.named(#$name, $value)';
  }
}
