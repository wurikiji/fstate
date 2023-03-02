import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:fstate_generator/src/injections/inject_from.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:fstate_generator/src/wrapper/basic_constructor.dart';
import 'package:source_gen/source_gen.dart';

import 'src/utils/element.dart';

Builder coreBuilder(BuilderOptions option) {
  return SharedPartBuilder(
    [
      KeyGenerator(),
    ],
    'fstate',
  );
}

class KeyGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fstates = library.annotatedWith(fstateAnnotationChecker);
    final fstateClasses = fstates.where(
      (element) => element.element is ClassElement,
    );

    return fstateClasses
        .map(classElementFromAnnotation)
        .map(baseConstructorFromClassElement)
        .map((constructor) {
      final className = constructor.constructor.enclosingElement.displayName;
      String constructorName = constructor.constructor.displayName;
      if (!constructorName.contains('.')) {
        constructorName = '$constructorName.new';
      }
      final injectionParameters = constructor.parameters
          .where(hasInjectionAnnotation)
          .map((e) => InjectionFrom(constructor, e));

      if (injectionParameters.isEmpty) {
        return 'const \$${sentenceCaseToCamelCase(className)} = FstateKey<$className>(builder: $constructorName);';
      }

      for (final i in injectionParameters) {
        if (i is InjectFromFstateKey) {
          print(i.injectedKey);
        }
      }
      return '';
    }).join('\n');
  }
}

BaseConstructor baseConstructorFromClassElement(ClassElement element) {
  final constructors = element.constructors.where(
    (element) => constructorAnnotationChecker.hasAnnotationOf(element),
  );

  if (constructors.isEmpty) {
    throw InvalidGenerationSourceError(
      'No constructor with @constructor annotation found in ${element.displayName}',
      element: element,
    );
  }

  if (constructors.length > 1) {
    throw InvalidGenerationSourceError(
      'Multiple constructors with @constructor annotation found in ${element.displayName}',
      element: element,
    );
  }

  return BaseConstructor(constructors.first);
}

Element elementFromAnnotation(AnnotatedElement annotation) {
  return annotation.element;
}

ClassElement classElementFromAnnotation(AnnotatedElement annotation) {
  return elementFromAnnotation(annotation) as ClassElement;
}
