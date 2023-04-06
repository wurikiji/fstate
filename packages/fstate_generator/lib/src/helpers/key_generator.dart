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

  String _generateKey() {
    final keyName = baseName.toKeyName();
    return '''
class $keyName extends FstateKey {
  ${_generateKeyConstructor()}
}
''';
  }

  String _generateKeyConstructor() {
    final keyName = baseName.toKeyName();
    return '''
$keyName({
  ${_generateConstructorParams()}
}) : super(
  $stateType,
  [${_listParamNames()}]
);
''';
  }

  String _generateConstructorParams() {
    return params
        .map((e) =>
            '${e.type.endsWith('?') || e.defaultValue != null ? '' : 'required'} ${e.type} ${e.name} ${e.defaultValue != null ? '= ${e.defaultValue}' : ''}')
        .join(',');
  }

  String _listParamNames() {
    return params.map((e) => e.name).join(', ');
  }

  @override
  String toString() {
    return _generateKey();
  }
}

extension KeyGeneratorExt on String {
  String toKeyName() {
    return '_${pascalCase}Key';
  }
}
