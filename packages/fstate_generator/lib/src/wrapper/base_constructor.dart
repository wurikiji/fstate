import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../type_checkers/annotations.dart';

class BaseConstructor {
  const BaseConstructor(this.constructor);

  final ConstructorElement constructor;

  bool get isConstConstructor => constructor.isConst;
  List<ParameterElement> get parameters => constructor.parameters;
  Iterable<ParameterElement> get positionalParameters =>
      parameters.where((element) => element.isPositional);
  Iterable<ParameterElement> get namedParameters =>
      parameters.where((element) => element.isNamed);

  @override
  String toString() => constructor.displayName;
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
