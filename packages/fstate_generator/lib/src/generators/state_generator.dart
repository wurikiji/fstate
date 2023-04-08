import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

import '../helpers/alternator.dart';
import '../helpers/factory_generator.dart';
import '../helpers/field.dart';
import '../helpers/key_generator.dart';
import '../helpers/parameter.dart';
import '../helpers/state_generator.dart';
import '../type_checkers/annotations.dart';

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
                final autoinjection =
                    finjectAnnotationChecker.hasAnnotationOf(e);
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
                return Parameter(
                  type: type,
                  name: e.name,
                  defaultValue: e.defaultValueCode,
                  autoInject: autoinjection,
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
          final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
          String type = e.type
              .getDisplayString(withNullability: true)
              .replaceAll('*', '');
          if (e.isPositional) {
            return ParameterWithMetadata.positional(
              name: e.name,
              type: type,
              position: e.parameters.indexOf(e),
              defaultValue: e.defaultValueCode,
              autoInject: autoinjection,
            );
          }
          return ParameterWithMetadata.named(
            type: type,
            name: e.name,
            defaultValue: e.defaultValueCode,
            autoInject: autoinjection,
          );
        }).toList();
        final returnType = e.returnType
            .getDisplayString(withNullability: true)
            .replaceAll('*', '');
        if (isPure) {
          return FstateAction.emitter(
            name: e.name,
            returnType: returnType,
            params: params,
          );
        }
        return FstateAction.method(
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
        return FstateAction.field(
          name: e.name,
          returnType: returnType,
        );
      });

      final normalFields = e.fields
          .where(
              (element) => !factionAnnotationChecker.hasAnnotationOf(element))
          .map((e) {
        /// convert to [FstateField]
        final type =
            e.type.getDisplayString(withNullability: true).replaceAll('*', '');
        final name = e.name;
        final isFinal = e.isFinal;
        final isGetter = e.getter != null;
        final isSetter = e.setter != null;
        return FstateField(
          name: name,
          type: type,
          isFinal: isFinal,
          isGetter: isGetter,
          isSetter: isSetter,
        );
      }).toList();
      return ExtendedStateGenerator(
        baseName: e.displayName,
        constructor: constructor.displayName,
        constructorParams: parameters.map((e) {
          final autoinjection = finjectAnnotationChecker.hasAnnotationOf(e);
          String type = e.type
              .getDisplayString(withNullability: true)
              .replaceAll('*', '');
          return e.isPositional
              ? ParameterWithMetadata.positional(
                  name: e.name,
                  type: type,
                  position: parameters.indexOf(e),
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
        actions: [...methodActions, ...fieldActions],
        fields: normalFields,
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
                    ?.toFunctionValue() !=
                null)
            .map((e) {
          final target = e.name;
          final annotation = finjectAnnotationChecker.annotationsOf(e).first;
          final alternatorName =
              annotation.getField('alternator')!.toFunctionValue()!.name;
          return AlternatorArg(target: target, alternatorName: alternatorName);
        });
        return FstateFactoryGenerator(
          baseName: e.displayName,
          type: e.displayName,
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
