import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

import '../type_checkers/annotations.dart';
import '../type_checkers/key.dart';

String sentenceCaseToCamelCase(String input) {
  return input[0].toLowerCase() + input.substring(1);
}

DartObject getInjectionAnnotation(Element element) =>
    injectAnnotationChecker.firstAnnotationOf(element)!;

DartObject getInjectionFromField(Element element) =>
    injectAnnotationChecker.firstAnnotationOf(element)!.getField('from')!;

bool isElementFromFunction(Element element) =>
    getInjectionFromField(element).toFunctionValue() == null ? false : true;

bool isElementNull(Element element) => getInjectionFromField(element).isNull;

bool isElementFromFstateKey(Element element) {
  final object = getInjectionFromField(element);
  final from = object.toTypeValue()?.element;
  if (from == null) return true;
  return fstateKeyChecker.isAssignableFrom(element);
}

bool hasInjectionAnnotation(Element element) =>
    injectAnnotationChecker.hasAnnotationOf(element);
