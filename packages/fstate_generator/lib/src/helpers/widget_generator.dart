import 'package:fstate_generator/src/helpers/parameter.dart';

import 'alternator.dart';

class FstateWidgetGenerator {
  FstateWidgetGenerator({
    required this.baseName,
    required this.widgetBuilder,
    List<ParameterWithMetadata> params = const [],
    this.alternators = const [],
  }) : params = params.where((element) => element.name != 'key').toList();

  final String baseName;
  final String widgetBuilder;
  final List<ParameterWithMetadata> params;
  final List<AlternatorArg> alternators;

  @override
  String toString() {
    final familyParams = params.where(
      (element) => !element.autoInject,
    );
    final constructorParams = paramsToFieldsInConstructor(familyParams);
    final fields = paramsToFinalFields(familyParams);
    return '''
class ${baseName.extendedWidget} extends FstateWidget {
  const ${baseName.extendedWidget}(
    {
      super.key,
      ${constructorParams.isNotEmpty ? constructorParams : ''}
    }
  );

  $fields

  @override
  Function get widgetBuilder => $widgetBuilder;

  @override
  List<Param> get params => [
    ${joinParamsToFstateWidgetParams(params)}
  ];

  @override
  Map<dynamic, Alternator> get alternators => {
    ${joinAlternatorsToMap(alternators)}
  };
}
''';
  }
}

String joinParamsToFstateWidgetParams(List<ParameterWithMetadata> params) {
  return params.map((e) => e.toFstateWidgetParam()).join(',\n');
}

extension _WidgetGeneratorExt on String {
  String get extendedWidget => '\$$this';
}

extension ToFstateWidgetParam on ParameterWithMetadata {
  String toFstateWidgetParam() {
    final value = autoInject ? '\$$type()' : defaultValue ?? name;
    if (isPositional) {
      return 'Param.positional($position, $value)';
    }
    return 'Param.named(#$name, $value)';
  }
}

String paramsToFinalFields(Iterable<ParameterWithMetadata> params) {
  return params.map((e) => 'final ${e.type} ${e.name};').join();
}

String paramsToFieldsInConstructor(Iterable<ParameterWithMetadata> params) {
  return params
      .map((e) =>
          '${e.isRequired ? 'required' : ''} this.${e.name} ${e.defaultValue != null ? '= $e.defaultValue' : ''}')
      .join(',');
}
