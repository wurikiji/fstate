import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

import '../helpers/alternator.dart';
import '../helpers/widget_generator.dart';

class WidgetGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fwidgets = library.annotatedWith(fwidgetAnnotationChecker);
    final factoryGenerators =
        fwidgets.map((e) => e.element as ClassElement).map(
      (e) {
        final constructor = e.constructors.firstWhere((element) =>
            fconstructorAnnotationChecker.hasAnnotationOf(element));

        final injections = constructor.parameters.where(
          (element) => finjectAnnotationChecker.hasAnnotationOf(element),
        );

        final alternators = injections
            .where((e) => finjectAnnotationChecker.hasAnnotationOf(e))
            .where((e) =>
                finjectAnnotationChecker
                    .firstAnnotationOf(e)!
                    .getField('alternator')
                    ?.toFunctionValue() !=
                null)
            .map((e) {
          final target = e.name;
          final annotation = finjectAnnotationChecker.annotationsOf(e).first;
          final alternatorName =
              annotation.getField('alternator')!.toFunctionValue()!.name;
          return AlternatorArg(target: target, alternatorName: alternatorName);
        });
        return FstateWidgetGenerator(
          baseName: e.displayName,
          params: constructor.parameters.map((e) {
            final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
            String type = e.type
                .getDisplayString(withNullability: true)
                .replaceAll('*', '');
            final derivedFrom = finjectAnnotationChecker
                .firstAnnotationOf(e)
                ?.getField('from')
                ?.toFunctionValue();

            if (autoinjection && derivedFrom != null) {
              type = derivedFrom.name.pascalCase;
            }

            return e.isPositional
                ? ParameterWithMetadata.positional(
                    name: e.name,
                    type: type,
                    position: constructor.parameters.indexOf(e),
                    defaultValue: e.defaultValueCode,
                    autoInject: autoinjection,
                  )
                : ParameterWithMetadata.named(
                    type: type,
                    name: e.name,
                    defaultValue: e.defaultValueCode,
                    autoInject: autoinjection,
                  );
          }).toList(),
          widgetBuilder: constructor.displayName.contains('.')
              ? constructor.displayName
              : '${constructor.displayName}.new',
          alternators: alternators.toList(),
        );
      },
    );
    final outputs = factoryGenerators.map((e) => e.toString()).join('\n');
    return outputs;
  }
}
