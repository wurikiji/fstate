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
    final constructorParams = joinParamsToNamedParams(familyParams);
    return '''
class ${baseName.extendedWidget} extends FstateWidget {
  ${baseName.extendedWidget}(
    {
      super.key,
      ${constructorParams.isNotEmpty ? constructorParams : ''}
    }
  );

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
