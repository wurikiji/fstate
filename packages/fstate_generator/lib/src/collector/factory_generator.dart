import '../generators/state_generator.dart';
import '../utils/string.dart';
import 'data.dart';
import 'helpers/param.dart';

String generateStateFactory(
  String name,
  String constructor,
  String stateType,
  List<ParameterMetadata> params,
  bool keepAlive,
) {
  final isSelector = name == constructor;
  final paramNames = params.map((e) => e.name).join(', ');
  final originalParams = params.toFactoryParams(true);
  final paramFields = params.toFactoryFields();
  final builder = name.toExtendedStateName();
  final keyArgs = [constructor, paramNames]
      .where((element) => element.isNotEmpty)
      .join(', ');
  final fstateParamList = params.toFstateParamList();

  return '''
class ${name.toFactoryName()} extends FstateFactory {
  ${name.toFactoryName()}($originalParams) : \$stateKey = FstateKey('$stateType', [$keyArgs]);

  $paramFields

  @override
  final FstateKey \$stateKey;

  @override
  Function get \$stateBuilder => $builder${isSelector ? '' : '.new'};

  @override
  late final List<Param> \$params = [$fstateParamList];

  @override
  Map<dynamic, FTransformer> get \$transformers => {};

  @override
  bool get \$keepAlive => $keepAlive;
}
''';
}

String generateInjectAnnotation(String name, List<ParameterMetadata> params) {
  final autoInjectable = params.every((element) => !element.needManualInject);

  return '''
const inject\$$name${autoInjectable ? '' : r'$'} = Finject($name, $autoInjectable);
''';
}
