import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../type_checkers/annotations.dart';
import '../type_checkers/key.dart';

String sentenceCaseToCamelCase(String input) {
  return input[0].toLowerCase() + input.substring(1);
}

DartObject? getInjectionAnnotation(Element element) =>
    injectAnnotationChecker.firstAnnotationOf(element);

DartObject? getInjectionFromField(Element element) =>
    getInjectionAnnotation(element)!.getField('from');

bool isInjectionFromFunction(Element element) =>
    getInjectionFromField(element)?.toFunctionValue() == null ? false : true;

bool isInjectionFromNull(Element element) =>
    getInjectionFromField(element)?.isNull ?? true;

bool isElementFromFstateKey(Element element) {
  final object = getInjectionFromField(element);
  final from = object?.toTypeValue()?.element;
  if (from == null) return true;
  return fstateKeyChecker.isAssignableFrom(element);
}

bool hasInjectionAnnotation(Element element) =>
    injectAnnotationChecker.hasAnnotationOf(element);

Element elementFromAnnotation(AnnotatedElement annotation) {
  return annotation.element;
}

ClassElement classElementFromAnnotation(AnnotatedElement annotation) {
  return elementFromAnnotation(annotation) as ClassElement;
}
