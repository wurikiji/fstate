import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../collector/data.dart';
import '../collector/helpers/constructor.dart';
import '../collector/helpers/param.dart';
import '../type_checkers/annotations.dart';
import '../utils/string.dart';
import 'state_generator.dart';

class WidgetGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fwidgets = library.annotatedWith(fwidgetAnnotationChecker);
    return fwidgets
        .where((element) => element.element is ClassElement)
        .map((e) => e.element as ClassElement)
        .map((e) {
      final constructor =
          parseConstructor(e.constructors.fstateDefaultConstructor);
      final name = e.name;
      final params =
          constructor.params.where((element) => element.name != 'key').toList();

      var factoryParams = params.toFactoryParams(true);
      if (factoryParams.endsWith('}')) {
        factoryParams = '''
${factoryParams.substring(0, factoryParams.length - 1)}, 
this.\$onLoading,Key? key}
''';
      } else {
        factoryParams = [
          factoryParams,
          '''
{
this.\$onLoading,Key? key
}'''
        ].where((s) => s.isNotEmpty).join(',');
      }
      final fields = params.toFactoryFields();

      return '''
class ${name.toWidgetName()} extends FstateWidget {
  const ${name.toWidgetName()}($factoryParams) : super(key: key);

  $fields

  @override
  List<Param> get \$params => [
    ${constructor.params.toFwidgetParamList()}
  ];

  @override
  Map<dynamic, FTransformer> get \$transformers => { };

  @override
  Function get \$widgetBuilder => $name.${constructor.name};

  @override
  final Widget Function(BuildContext)? \$onLoading;
}
''';
    }).join('');
  }
}

extension ToWidgetName on String {
  String toWidgetName() {
    return '\$$this';
  }
}

extension ToFstateParamList on List<ParameterMetadata> {
  String toFwidgetParamList() {
    return map((e) {
      final name = e.name;
      final place = e.isPositional ? 'positional' : 'named';
      final position = e.isPositional ? e.position : '#${e.name}';
      if (e.injectedFrom == null) {
        return 'Param.$place($position, $name)';
      }
      final value = '''
$name ${e.needManualInject ? '' : '?? ${e.injectedFrom!.toFactoryName()}()'}
''';
      return 'Param.$place($position, $value)';
    }).join(', ');
  }
}
