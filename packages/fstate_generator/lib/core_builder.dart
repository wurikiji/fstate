import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:fstate_generator/src/injections/inject_from.dart';
import 'package:fstate_generator/src/injections/injection_place.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'src/utils/element.dart';
import 'src/wrapper/base_constructor.dart';

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
        .map(generateInjectionCode)
        .join('\n');
  }
}

String generateInjectionCode(BaseConstructor constructor) {
  final className = constructor.constructor.enclosingElement.displayName;
  String constructorName = constructor.constructor.displayName;

  if (!constructorName.contains('.')) {
    constructorName = '$constructorName.new';
  }

  if (constructor.parameters.isEmpty) {
    return 'const \$${sentenceCaseToCamelCase(className)} = FstateKey<$className>(builder: $constructorName);';
  }

  final injectionParameters = constructor.parameters
      .where(hasInjectionAnnotation)
      .map((e) => InjectionFrom(constructor, e));

  final injectionPlaces = injectionParameters.map(InjectionPlace.new).toList();
  final positionals = injectionPlaces
      .whereType<PositionalInjection>()
      .map((e) => e.toString())
      .join(',');
  final named = injectionPlaces
      .whereType<NamedInjection>()
      .map((e) => e.toString())
      .join(',');

  final keyClassName = '_${className}Key';
  return '''
const \$${sentenceCaseToCamelCase(className)} = $keyClassName(builder: $constructorName);
class $keyClassName extends FstateKey<$className> {
  const $keyClassName({required super.builder});

  @override
  List<PositionalParam> get additionalPositionalInputs => [$positionals];

  @override
  Map<Symbol, dynamic> get additionalNamedInputs => {$named};
}
''';
}
