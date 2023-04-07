import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:recase/recase.dart';

class FstateKeyGenerator {
  FstateKeyGenerator({
    required this.baseName,
    required this.stateType,
    required this.params,
  })  : assert(params.isNotEmpty, 'params contains at least one element'),
        assert(baseName.isNotEmpty, 'baseName should not be empty'),
        assert(stateType.isNotEmpty, 'stateType should not be empty');

  final String baseName;
  final String stateType;
  final List<Parameter> params;

  @override
  String toString() {
    final keyName = baseName.toKeyName();
    return '''
class $keyName extends FstateKey {
  ${_generateKeyConstructor()}
}
''';
  }

  String _generateKeyConstructor() {
    final keyName = baseName.toKeyName();
    final params = this.params.where((element) => !element.autoInject);
    return '''
$keyName({
  ${joinParamsToNamedParams(params)}
}) : super(
  $stateType,
  [${joinParamNames(params)}]
);
''';
  }
}

extension KeyGeneratorExt on String {
  String toKeyName() {
    return '_${pascalCase}Key';
  }
}
