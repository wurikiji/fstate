import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../type_checkers/annotations.dart';
import '../../utils/string.dart';
import '../data.dart';

List<ParameterMetadata> collectParams(ExecutableElement executable) {
  final params = executable.parameters;
  final positional = params.where((p) => p.isPositional).map(
        (e) => ParameterMetadata(
          type: e.type
              .getDisplayString(withNullability: true)
              .replaceAll('*', ''),
          name: e.name,
          position: params.indexOf(e),
          defaultValue: e.defaultValueCode,
          injectedFrom: calculateInjectFrom(e),
          transformer: calculateTransformer(e),
          needManualInject: !isParamAutoInjectable(e),
        ),
      );
  final named = params.where((p) => p.isNamed).map(
        (e) => ParameterMetadata(
          type: e.type
              .getDisplayString(withNullability: true)
              .replaceAll('*', ''),
          name: e.name,
          defaultValue: e.defaultValueCode,
          injectedFrom: calculateInjectFrom(e),
          transformer: calculateTransformer(e),
          needManualInject: !isParamAutoInjectable(e),
        ),
      );

  return positional.followedBy(named).toList();
}

bool isParamAutoInjectable(ParameterElement param) {
  return param.hasDefaultValue ||
      (calculateInjectFrom(param) != null && isAutoInjectableField(param));
}

const _injectionStart = r'@inject$';
String? calculateInjectFrom(ParameterElement param) {
  try {
    final annotation = finjectAnnotationChecker.firstAnnotationOfExact(param);
    final from = annotation?.getField('from')?.toFunctionValue();
    return from?.name;
  } catch (e) {
    if (e is! UnresolvedAnnotationException) {
      return null;
    }
    final source = e.annotationSource?.text;
    if (source?.startsWith(_injectionStart) ?? false) {
      final name = source!;
      final from =
          name.substring(_injectionStart.length).replaceAll(RegExp(r'\$$'), '');
      return from;
    }
    return null;
  }
}

bool isAutoInjectableField(ParameterElement param) {
  try {
    final annotation = finjectAnnotationChecker.firstAnnotationOf(param);
    final autoInjectable =
        annotation?.getField('autoInjectable')?.toBoolValue() ?? false;
    return autoInjectable;
  } catch (e) {
    if (e is! UnresolvedAnnotationException) {
      return false;
    }
    final source = e.annotationSource?.text;
    if (source?.startsWith(_injectionStart) ?? false) {
      final autoInjectable = !source!.endsWith(r'$');
      return autoInjectable;
    }
    return false;
  }
}

String? calculateTransformer(ParameterElement param) {
  final annotation = ftransformAnnotationChecker.firstAnnotationOf(
    param,
    throwOnUnresolved: false,
  );
  final from = annotation?.getField('transformer')?.toFunctionValue();
  return from?.name;
}

extension ToParams on List<ParameterMetadata> {
  String toOriginalParams(bool isField) {
    final positionalParams = where((element) => element.isPositional);
    final namedParams = where((element) => element.isNamed);

    final positionalParam = positionalParams
        .map((e) => e.toPositionalParam(isField, true))
        .join(', ');

    final namedParam = namedParams
        .map((e) => e.toNamedParam(isField))
        .join(', ')
        .trim()
        .wrappedWithBracketsIfNotEmpty;

    return [positionalParam, namedParam].where((e) => e.isNotEmpty).join(', ');
  }

  String toNamedParams(bool isField) {
    return map((e) => e.toNamedParam(isField))
        .join(', ')
        .trim()
        .wrappedWithBracketsIfNotEmpty;
  }
}

extension ToArgs on List<ParameterMetadata> {
  String toOriginalArgs() {
    final positionalArgs = where((element) => element.isPositional);
    final namedArgs = where((element) => element.isNamed);

    final positionalArg =
        positionalArgs.map((e) => e.toPositionalArg()).join(', ');

    final namedArg = namedArgs.map((e) => e.toNamedArg()).join(', ').trim();

    return [positionalArg, namedArg].where((e) => e.isNotEmpty).join(', ');
  }
}

extension ToField on List<ParameterMetadata> {
  String toFields() {
    return map((e) => e.toFinalField()).join('');
  }
}

extension ToFstateParamList on List<ParameterMetadata> {
  String toFstateParamList() {
    return map((e) {
      final name = e.name;
      if (e.injectedFrom == null) {
        return 'Param.named(#$name, $name)';
      }
      final value = '''
$name ${e.needManualInject ? '' : '?? ${e.injectedFrom!.toFactoryName()}()'}
''';
      return 'Param.named(#$name, $value)';
    }).join(', ');
  }
}

extension ToFactoryParams on List<ParameterMetadata> {
  String toFactoryParams(bool isField) {
    final positionalParams = where(
      (element) =>
          element.isPositional &&
          element.isRequired &&
          (element.injectedFrom == null || element.needManualInject),
    ).toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    final namedParams = where(
      (element) =>
          element.isNamed ||
          !element.isRequired ||
          (element.injectedFrom != null && !element.needManualInject),
    );

    final positionalParam = positionalParams.map((e) {
      return e.toPositionalParam(isField, true);
    }).join(', ');

    final namedParam = namedParams
        .map((e) {
          if (e.injectedFrom == null) {
            return e.toNamedParam(isField);
          }
          final required = e.needManualInject ? 'required' : '';
          return '$required this.${e.name}';
        })
        .join(', ')
        .trim()
        .wrappedWithBracketsIfNotEmpty;

    return [positionalParam, namedParam].where((e) => e.isNotEmpty).join(', ');
  }
}
