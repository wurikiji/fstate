import 'package:analyzer/dart/element/element.dart';
import 'package:fstate_generator/src/generators/selector_generator.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:test/test.dart';

import '../../test_utils/resolver.dart';
import '../../test_utils/string_extension.dart';
import 'test_data/selector_data.dart';

void main() {
  group('extendSelector', () {
    for (final target in $selectorTestData) {
      testWithLibraryReader(target.name, target.source,
          (library, resolver, id) {
        final fstates = library
            .annotatedWith(fstateAnnotationChecker)
            .map((e) => e.element as FunctionElement)
            .map((e) => SelectorFactory(e))
            .first;
        final extendedSelector = fstates.generateExtendedSelector();
        expect(
          extendedSelector.format(),
          target.expectedExtendedSelector.format(),
        );
      });
    }
  });

  group('generateFactory for selectors', () {
    for (final target in $selectorTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, resolver, id) {
          final fstate = library
              .annotatedWith(fstateAnnotationChecker)
              .map((e) => e.element as FunctionElement)
              .map((e) => SelectorFactory(e))
              .first;
          final factory = fstate.generateFactory();
          expect(
            factory.format(),
            target.expectedFactory.format(),
          );
        },
      );
    }
  });
  group('generateInjectAnnotation', () {
    for (final target in $selectorTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, resolver, id) {
          final fstate = library
              .annotatedWith(fstateAnnotationChecker)
              .map((e) => e.element as FunctionElement)
              .map((e) => SelectorFactory(e))
              .first;
          final annotation = fstate.generateAnnotation();
          expect(
            annotation.format(),
            target.expectedAnnotation.format(),
          );
        },
      );
    }
  });
}
