import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../collector/data.dart';
import '../collector/factory_generator.dart';
import '../collector/helpers/param.dart';
import '../type_checkers/annotations.dart';
import '../utils/string.dart';

class SelectorGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final fstates = library
        .annotatedWith(fstateAnnotationChecker)
        .where((element) => element.element is FunctionElement)
        .map((e) => e.element as FunctionElement);

    return fstates.map((e) {
      final fac = SelectorFactory(e);
      return '''
${fac.generateAnnotation()}

${fac.generateExtendedSelector()}

${fac.generateFactory()}
''';
    }).join();
  }
}

class SelectorFactory {
  SelectorFactory(this.element)
      : params = collectParams(element),
        name = element.name,
        returnType = element.returnType.toString();
  final FunctionElement element;
  final List<ParameterMetadata> params;
  final String name;
  final String returnType;

  bool get keepAlive =>
      fstateAnnotationChecker
          .firstAnnotationOf(element)
          ?.getField('keepAlive')
          ?.toBoolValue() ??
      false;

  String generateAnnotation() => generateInjectAnnotation(name, params);

  String generateFactory() =>
      generateStateFactory(name, name, returnType, params, keepAlive);

  String generateExtendedSelector() {
    final namedParam = [
      r'$setNextState',
      params.map((e) => e.toNamedParam(false)).join(', ')
    ]
        .where((element) => element.isNotEmpty)
        .join(', ')
        .wrappedWithBracketsIfNotEmpty;

    final args = params.toOriginalArgs();
    final isStream = element.returnType.isDartAsyncStream ||
        (element.isAsynchronous && element.isGenerator);
    final returnsFuture = !isStream &&
        (element.returnType.isDartAsyncFuture ||
            element.returnType.isDartAsyncFutureOr ||
            element.isAsynchronous);

    return '''
$returnType ${name.toExtendedStateName()}($namedParam) ${returnsFuture ? 'async' : ''} {
  final result = $name($args);
  try {
    return ((${returnsFuture ? 'await' : ''} result) as dynamic).toFstate().\$buildState(\$setNextState);
  } catch (_) {
    return result;
  }
}
''';
  }
}
