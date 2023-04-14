import 'package:analyzer/dart/element/element.dart';

import '../../type_checkers/annotations.dart';
import '../../utils/dart_type.dart';
import '../data.dart';
import 'param.dart';

List<MethodMetadata> collectNormalMethods(ClassElement element) {
  return element.methods
      .where(
        (element) => !factionAnnotationChecker.hasAnnotationOfExact(element),
      )
      .map(
        (e) => MethodMetadata(
          name: e.name,
          isAsynchronous: e.returnType.isDartAsyncFuture ||
              e.isAsynchronous ||
              e.returnType.isDartAsyncFutureOr ||
              e.returnType.isDartAsyncStream,
          isStream: e.returnType.isDartAsyncStream ||
              (e.isAsynchronous && e.isGenerator),
          params: collectParams(e).toList(),
          returnType: e.returnType.typeWithNullability,
        ),
      )
      .toList();
}

List<MethodMetadata> collectActionMethods(ClassElement element) {
  return element.methods
      .where(
        (element) => factionAnnotationChecker.hasAnnotationOfExact(element),
      )
      .map(
        (e) => MethodMetadata(
          name: e.name,
          params: collectParams(e).toList(),
          isAsynchronous: e.returnType.isDartAsyncFuture ||
              e.isAsynchronous ||
              e.returnType.isDartAsyncFutureOr ||
              e.returnType.isDartAsyncStream,
          isStream: e.returnType.isDartAsyncStream ||
              (e.isAsynchronous && e.isGenerator),
          isEmitter: factionAnnotationChecker
                  .firstAnnotationOfExact(e)
                  ?.getField('returnsNextState')
                  ?.toBoolValue() ??
              false,
          returnType: e.returnType.typeWithNullability,
        ),
      )
      .map((e) {
    if (e.isEmitter && !e.returnType.contains(element.name)) {
      throw 'Method [${element.name}.${e.name}] is marked as an emitter, but it does not return a [${element.name}].';
    }
    return e;
  }).toList();
}

List<FieldMetadata> collectFields(ClassElement element) {
  return element.fields
      .map(
        (e) => FieldMetadata(
          name: e.name,
          type: e.type.typeWithNullability,
          isGetter: e.getter != null,
          isSetter: e.setter != null,
        ),
      )
      .toList();
}
