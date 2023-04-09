import 'package:analyzer/dart/element/element.dart';
import 'package:fstate_generator/src/generators/state_generator.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:test/test.dart';

import '../../test_utils/resolver.dart';
import '../../test_utils/string_extension.dart';
import 'test_data/state_generator_test_data.dart';

void main() {
  group('generateAnnotation', () {
    for (final target in $stateGeneratorTestData) {
      testWithLibraryReader(target.name, target.source,
          (library, resolver, id) {
        final fac = library
            .annotatedWith(fstateAnnotationChecker)
            .where((element) => element.element is ClassElement)
            .map((e) => e.element as ClassElement)
            .map(StateFactory.fromClassElement)
            .first;
        final actual = fac.generateAnnotation();
        expect(actual.format(), target.expectedInjectAnnotation.format());
      });
    }
  });

  group('generateExtendedState', () {
    for (final target in $stateGeneratorTestData) {
      testWithLibraryReader(target.name, target.source,
          (library, resolver, id) {
        final fac = library
            .annotatedWith(fstateAnnotationChecker)
            .where((element) => element.element is ClassElement)
            .map((e) => e.element as ClassElement)
            .map(StateFactory.fromClassElement)
            .first;
        final actual = fac.generateExtendedState();
        expect(actual.format(), target.expectedExtendedState.format());
      });
    }
  });
  group('generateFactory', () {
    for (final target in $stateGeneratorTestData) {
      testWithLibraryReader(target.name, target.source,
          (library, resolver, id) {
        final fac = library
            .annotatedWith(fstateAnnotationChecker)
            .where((element) => element.element is ClassElement)
            .map((e) => e.element as ClassElement)
            .map(StateFactory.fromClassElement)
            .first;
        final actual = fac.generateFactory();
        expect(actual.format(), target.expectedFactory.format());
      });
    }
  });

  group('generateToFstateExtension', () {
    for (final target in $stateGeneratorTestData) {
      testWithLibraryReader(target.name, target.source,
          (library, resolver, id) {
        final fac = library
            .annotatedWith(fstateAnnotationChecker)
            .where((element) => element.element is ClassElement)
            .map((e) => e.element as ClassElement)
            .map(StateFactory.fromClassElement)
            .first;
        final actual = fac.generateToFstateExtension();
        expect(actual.format(), target.expectedExtension.format());
      });
    }
  });
}
