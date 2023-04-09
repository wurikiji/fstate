import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../collector/data.dart';
import '../collector/factory_generator.dart';
import '../collector/helpers/class_state.dart';
import '../collector/helpers/constructor.dart';
import '../collector/helpers/param.dart';
import '../type_checkers/annotations.dart';
import '../utils/string.dart';

class StateGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final generated = library
        .annotatedWith(fstateAnnotationChecker)
        .where((element) => element.element is ClassElement)
        .map((e) => e.element as ClassElement)
        .map(StateFactory.fromClassElement)
        .map(
          (e) => '''
${e.generateAnnotation()}

${e.generateExtendedState()}

${e.generateFactory()}

${e.generateToFstateExtension()}
''',
        )
        .join();
    return generated;
  }
}

class StateFactory {
  StateFactory(this.fstateMetadata);
  StateFactory.fromClassElement(ClassElement e)
      : fstateMetadata = FstateMetadata(
          name: e.name,
          constructors: [
            parseConstructor(e.constructors.fstateDefaultConstructor)
          ],
          actionMethods: collectActionMethods(e),
          normalMethods: collectNormalMethods(e),
          fields: collectFields(e),
        );
  final FstateMetadata fstateMetadata;
  ConstructorMetadata get constructor => fstateMetadata.constructors.first;

  String generateAnnotation() {
    final constructor = fstateMetadata.constructors.first;
    return generateInjectAnnotation(fstateMetadata.name, constructor.params);
  }

  String generateFactory() {
    return generateStateFactory(
      fstateMetadata.name,
      '${fstateMetadata.name}.${constructor.name}',
      fstateMetadata.name,
      constructor.params,
    );
  }

  String generateToFstateExtension() {
    return '''
extension ${fstateMetadata.name}ToFstateExtension on ${fstateMetadata.name} {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      (\$setNextState) => ${fstateMetadata.name.toExtendedStateName()}.from(
        this,
        \$setNextState: \$setNextState,
      ),
    );
  }
}
''';
  }

  String generateExtendedState() {
    final name = fstateMetadata.name;
    final params = constructor.params;
    final namedParam = [
      r'required this.$setNextState',
      params.map((e) => e.toNamedParam(false)).join(', ')
    ]
        .where((element) => element.isNotEmpty)
        .join(', ')
        .wrappedWithBracketsIfNotEmpty;

    final args = params.toOriginalArgs();
    final actionMethods = fstateMetadata.actionMethods
        .map((e) => e.toActionMethodOverride(name))
        .join();
    final normalMethods = fstateMetadata.normalMethods
        .map((e) => e.toMethodOverride())
        .join('\n');
    final fields =
        fstateMetadata.fields.map((e) => e.toFieldOverride()).join('\n');

    return '''
class ${name.toExtendedStateName()} implements $name {
  ${name.toExtendedStateName()}($namedParam) : _state = $name.${constructor.name}($args);

  ${name.toExtendedStateName()}.from(this._state, {required this.\$setNextState,});

  final void Function($name) \$setNextState;
  final $name _state;

  $fields

  $normalMethods

  $actionMethods
}
''';
  }
}

extension OverrideActionMethod on MethodMetadata {
  String toActionMethodOverride(String stateName) {
    if (isEmitter && !isStream) {
      return toEmitterMethodOverride(stateName);
    }
    final params = this.params.toOriginalParams(false);
    final args = this.params.toOriginalArgs();
    return [
      '''
@override
$returnType $name($params) {
  final result = _state.$name($args);
''',
      if (!isAsynchronous || isStream) ...[
        '''
  \$setNextState(${stateName.toExtendedStateName()}.from(_state, \$setNextState: \$setNextState));
''',
        returnType == 'void' ? '' : 'return result;',
      ] else if (isAsynchronous && !isStream) ...[
        '''
  return result.then((r) {
    \$setNextState(${stateName.toExtendedStateName()}.from(_state, \$setNextState: \$setNextState));
    return r;
  });
'''
      ],
      '}',
    ].join();
  }

  String toEmitterMethodOverride(String stateName) {
    final params = this.params.toOriginalParams(false);
    final args = this.params.toOriginalArgs();
    return [
      '''
@override
$returnType $name($params) {
  final result = _state.$name($args);
''',
      if (!isAsynchronous) ...[
        '''
  final nextState = ${stateName.toExtendedStateName()}.from(result, \$setNextState: \$setNextState);
  \$setNextState(nextState);
  return nextState;
''',
      ] else if (isAsynchronous) ...[
        '''
  return result.then((r) {
    final nextState = ${stateName.toExtendedStateName()}.from(r, \$setNextState: \$setNextState);
    \$setNextState(nextState);
    return nextState;
  });
''',
      ],
      '}'
    ].join();
  }
}

extension OverrideMethod on MethodMetadata {
  String toMethodOverride() {
    final params = this.params.toOriginalParams(false);
    final args = this.params.toOriginalArgs();
    return '''
@override
$returnType $name($params) => _state.$name($args);
''';
  }
}

extension OverrideField on FieldMetadata {
  String toFieldOverride() {
    final getter = !isGetter
        ? ''
        : '''
@override
$type get $name => _state.$name;
''';
    final setter = !isSetter
        ? ''
        : '''
@override
set $name(newVal) => _state.$name = newVal;
''';
    return '''
$getter

$setter
''';
  }
}

extension FstateDefaultConstructor on List<ConstructorElement> {
  ConstructorElement get fstateDefaultConstructor {
    final annotated = where(
      (element) => fconstructorAnnotationChecker.hasAnnotationOf(element),
    );
    if (annotated.isNotEmpty) {
      return annotated.first;
    }
    return first;
  }
}

extension ToFactoryField on ParameterMetadata {
  String toInjectedFactoryField() {
    return '''
final ${injectedFrom!.toFactoryName()}${needManualInject ? '' : '?'} $name;
''';
  }
}

extension ToFactoryFields on List<ParameterMetadata> {
  String toFactoryFields() {
    return map((e) {
      if (e.injectedFrom == null) {
        return e.toFinalField();
      }
      return e.toInjectedFactoryField();
    }).join('');
  }
}
