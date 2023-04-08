import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:fstate_generator/src/helpers/factory_generator.dart';
import 'package:fstate_generator/src/helpers/key_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/helpers/selector_generator.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

import '../helpers/alternator.dart';

class SelectorGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fselectors = library.annotatedWith(fselectorAnnotationChecker);
    final fstateKeyGenerators =
        fselectors.map((e) => e.element as FunctionElement).map((e) {
      final constructor = e;
      String returnType = e.returnType
          .getDisplayString(withNullability: true)
          .replaceAll('*', '');

      if (returnType.contains('Function')) {
        returnType = 'Function';
      }

      return FstateKeyGenerator(
        baseName: e.displayName,
        stateType: returnType,
        params: [
          Parameter(
            type: 'Function',
            name: constructor.displayName,
            defaultValue: constructor.displayName,
            autoInject: false,
          ),
          ...constructor.parameters.map(
            (e) {
              final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
              String type = e.type
                  .getDisplayString(withNullability: true)
                  .replaceAll('*', '');
              final derivedFrom = finjectAnnotationChecker
                  .firstAnnotationOf(e)
                  ?.getField('derivedFrom')
                  ?.toFunctionValue();

              if (autoinjection && derivedFrom != null) {
                type = derivedFrom.name.pascalCase;
              }
              return Parameter(
                type: type,
                name: e.name,
                defaultValue: e.defaultValueCode,
                autoInject: autoinjection,
              );
            },
          ).toList()
        ],
      );
    });

    final extendedSelectorGenerator =
        fselectors.map((e) => e.element as FunctionElement).map((e) {
      final returnType = e.returnType
          .getDisplayString(withNullability: true)
          .replaceAll('*', '');
      final name = e.displayName;
      final paramsWithMetadata = e.parameters.map((e) {
        final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
        String type =
            e.type.getDisplayString(withNullability: true).replaceAll('*', '');
        return e.isPositional
            ? ParameterWithMetadata.positional(
                name: e.name,
                type: type,
                position: e.parameters.indexOf(e),
                defaultValue: e.defaultValueCode,
                autoInject: autoinjection,
              )
            : ParameterWithMetadata.named(
                type: type,
                name: e.name,
                defaultValue: e.defaultValueCode,
                autoInject: autoinjection,
              );
      }).toList();
      return ExtendedSelectorGenerator(
        returnType: returnType,
        name: name,
        params: paramsWithMetadata,
      );
    });

    final factoryGenerators =
        fselectors.map((e) => e.element as FunctionElement).map(
      (e) {
        final constructor = e;
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
        final returnType = e.returnType
            .getDisplayString(withNullability: true)
            .replaceAll('*', '');
        return FstateFactoryGenerator(
          baseName: e.displayName,
          type: returnType,
          params: constructor.parameters.map((e) {
            final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
            String type = e.type
                .getDisplayString(withNullability: true)
                .replaceAll('*', '');
            final derivedFrom = finjectAnnotationChecker
                .firstAnnotationOf(e)
                ?.getField('derivedFrom')
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
          stateConstructor: '_${constructor.displayName}',
          alternators: alternators.toList(),
        );
      },
    );

    final keys = fstateKeyGenerators.map((e) => e.toString()).join();
    final extendedSelector =
        extendedSelectorGenerator.map((e) => e.toString()).join();
    final factories = factoryGenerators.map((e) => e.toString()).join();

    final result = '''
$keys

$extendedSelector

$factories
'''
        .trim();
    return result;
  }
}
