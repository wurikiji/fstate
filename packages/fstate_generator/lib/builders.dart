import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:fstate_generator/src/helpers/factory_generator.dart';
import 'package:fstate_generator/src/helpers/key_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:fstate_generator/src/helpers/selector_generator.dart';
import 'package:fstate_generator/src/helpers/state_generator.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder coreBuilder(BuilderOptions option) {
  return SharedPartBuilder(
    [
      StateGenerator(),
      WidgetGenerator(),
      SelectorGenerator(),
    ],
    'fstate',
  );
}

class StateGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fstates = library.annotatedWith(fstateAnnotationChecker);
    final fstateKeyGenerators =
        fstates.map((e) => e.element as ClassElement).map((e) {
      final constructor = e.constructors.firstWhere(
          (element) => fconstructorAnnotationChecker.hasAnnotationOf(element));
      return FstateKeyGenerator(
          baseName: e.displayName,
          stateType: e.displayName,
          params: [
            Parameter(
              type: 'Function',
              name: '\$constructor',
              defaultValue: constructor.displayName.contains('.')
                  ? constructor.displayName
                  : '${constructor.displayName}.new',
              autoInject: false,
            ),
            ...constructor.parameters.map(
              (e) {
                return Parameter(
                  type: e.type
                      .getDisplayString(withNullability: true)
                      .replaceAll('*', ''),
                  name: e.name,
                  defaultValue: e.defaultValueCode,
                  autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                );
              },
            ).toList(),
          ]);
    });

    final extendedStateGenerators =
        fstates.map((e) => e.element as ClassElement).map((e) {
      final constructor = e.constructors.firstWhere(
          (element) => fconstructorAnnotationChecker.hasAnnotationOf(element));
      final parameters = constructor.parameters;
      final methodActions = e.methods
          .where((element) => factionAnnotationChecker.hasAnnotationOf(element))
          .map((e) {
        final isPure = factionAnnotationChecker
                .annotationsOf(e)
                .first
                .getField('returnsNextState')
                ?.toBoolValue() ??
            false;
        final params = e.parameters.map((e) {
          if (e.isPositional) {
            return ParameterWithMetadata.positional(
              name: e.name,
              type: e.type
                  .getDisplayString(withNullability: true)
                  .replaceAll('*', ''),
              position: e.parameters.indexOf(e),
              defaultValue: e.defaultValueCode,
              autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
            );
          }
          return ParameterWithMetadata.named(
            type: e.type
                .getDisplayString(withNullability: true)
                .replaceAll('*', ''),
            name: e.name,
            defaultValue: e.defaultValueCode,
            autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
          );
        }).toList();
        final returnType = e.returnType
            .getDisplayString(withNullability: true)
            .replaceAll('*', '');
        if (isPure) {
          return StateAction.emitter(
            name: e.name,
            returnType: returnType,
            params: params,
          );
        }
        return StateAction.method(
          name: e.name,
          returnType: returnType,
          params: params,
        );
      });
      final fieldActions = e.fields
          .where((element) => factionAnnotationChecker.hasAnnotationOf(element))
          .map((e) {
        final returnType =
            e.type.getDisplayString(withNullability: true).replaceAll('*', '');
        return StateAction.field(
          name: e.name,
          returnType: returnType,
        );
      });

      return ExtendedStateGenerator(
        baseName: e.displayName,
        constructor: constructor.displayName,
        constructorParams: parameters.map((e) {
          return e.isPositional
              ? ParameterWithMetadata.positional(
                  name: e.name,
                  type: e.type
                      .getDisplayString(withNullability: true)
                      .replaceAll('*', ''),
                  position: parameters.indexOf(e),
                  defaultValue: e.defaultValueCode,
                  autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                )
              : ParameterWithMetadata.named(
                  type: e.type
                      .getDisplayString(withNullability: true)
                      .replaceAll('*', ''),
                  name: e.name,
                  defaultValue: e.defaultValueCode,
                  autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                );
        }).toList(),
        actions: [...methodActions, ...fieldActions],
      );
    });

    final factoryGenerators = fstates.map((e) => e.element as ClassElement).map(
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
                    ?.variable !=
                null)
            .map((e) {
          final target = e.name;
          final annotation = finjectAnnotationChecker.annotationsOf(e).first;
          final alternatorName =
              annotation.getField('alternator')!.variable!.name;
          return AlternatorArg(target: target, alternatorName: alternatorName);
        });
        return FstateFactoryGenerator(
          baseName: e.displayName,
          type: e.displayName,
          params: constructor.parameters.map((e) {
            return e.isPositional
                ? ParameterWithMetadata.positional(
                    name: e.name,
                    type: e.type
                        .getDisplayString(withNullability: true)
                        .replaceAll('*', ''),
                    position: constructor.parameters.indexOf(e),
                    defaultValue: e.defaultValueCode,
                    autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                  )
                : ParameterWithMetadata.named(
                    type: e.type
                        .getDisplayString(withNullability: true)
                        .replaceAll('*', ''),
                    autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                    name: e.name,
                    defaultValue: e.defaultValueCode,
                  );
          }).toList(),
          stateConstructor:
              '_${constructor.displayName.contains('.') ? constructor.displayName : '${constructor.displayName}.new'}',
          alternators: alternators.toList(),
        );
      },
    );

    final keys = fstateKeyGenerators.map((e) => e.toString()).join();
    final extendedStates =
        extendedStateGenerators.map((e) => e.toString()).join();
    final factories = factoryGenerators.map((e) => e.toString()).join();

    return '''
$keys

$extendedStates

$factories
''';
  }
}

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
              return Parameter(
                type: e.type
                    .getDisplayString(withNullability: true)
                    .replaceAll('*', ''),
                name: e.name,
                defaultValue: e.defaultValueCode,
                autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
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
        return e.isPositional
            ? ParameterWithMetadata.positional(
                name: e.name,
                type: e.type
                    .getDisplayString(withNullability: true)
                    .replaceAll('*', ''),
                position: e.parameters.indexOf(e),
                defaultValue: e.defaultValueCode,
                autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
              )
            : ParameterWithMetadata.named(
                type: e.type
                    .getDisplayString(withNullability: true)
                    .replaceAll('*', ''),
                name: e.name,
                defaultValue: e.defaultValueCode,
                autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
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
                    ?.variable !=
                null)
            .map((e) {
          final target = e.name;
          final annotation = finjectAnnotationChecker.annotationsOf(e).first;
          final alternatorName =
              annotation.getField('alternator')!.variable!.name;
          return AlternatorArg(target: target, alternatorName: alternatorName);
        });
        final returnType = e.returnType
            .getDisplayString(withNullability: true)
            .replaceAll('*', '');
        return FstateFactoryGenerator(
          baseName: e.displayName,
          type: returnType,
          params: constructor.parameters.map((e) {
            return e.isPositional
                ? ParameterWithMetadata.positional(
                    name: e.name,
                    type: e.type
                        .getDisplayString(withNullability: true)
                        .replaceAll('*', ''),
                    position: constructor.parameters.indexOf(e),
                    defaultValue: e.defaultValueCode,
                    autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
                  )
                : ParameterWithMetadata.named(
                    type: e.type
                        .getDisplayString(withNullability: true)
                        .replaceAll('*', ''),
                    name: e.name,
                    defaultValue: e.defaultValueCode,
                    autoInject: finjectAnnotationChecker.hasAnnotationOf(e),
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

class WidgetGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fwidgets = library.annotatedWith(fwidgetAnnotationChecker);
    return super.generate(library, buildStep);
  }
}
