import 'package:fstate_generator/src/collector/data.dart';
import 'package:fstate_generator/src/collector/helpers/class_state.dart';
import 'package:test/test.dart';

import '../../../test_utils/json_comparison.dart';
import '../../../test_utils/resolver.dart';
import 'test_data/class_state_test_data.dart';

void main() {
  group('collectNormalMethods', () {
    for (var target in $fstateTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, _, __) async {
          final classs = library.findType(target.className)!;
          final actual = collectNormalMethods(classs);
          expectObjectJson(
            actual,
            target.expected.normalMethods,
          );
        },
      );
    }
  });
  group('collectActionMethods', () {
    for (var target in $fstateTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, _, __) async {
          final classs = library.findType(target.className)!;
          final actual = collectActionMethods(classs);
          expectObjectJson(
            actual,
            target.expected.actionMethods,
          );
        },
      );
    }

    testWithLibraryReader(
      'parse emitter',
      r'''
import 'package:fstate_annotation/fstate_annotation.dart';

@Fstate()
class Counter {
  @Faction(returnsNextState: true)
  Counter increment() {
    return Counter();
  }
}
''',
      (library, resolver, id) {
        final classs = library.findType('Counter')!;
        final actual = collectActionMethods(classs);
        expectObjectJson(
          actual,
          [
            MethodMetadata(
              name: 'increment',
              returnType: 'Counter',
              isAsynchronous: false,
              isStream: false,
              isEmitter: true,
            ),
          ],
        );
      },
    );

    testWithLibraryReader(
      'throws on emitter return type mismatch',
      r'''
import 'package:fstate_annotation/fstate_annotation.dart';

@Fstate()
class Counter {
  @Faction(returnsNextState: true)
  int increment() {
    return 0;
  }
}
''',
      (library, resolver, id) {
        final classs = library.findType('Counter')!;
        expect(
          () {
            collectActionMethods(classs);
          },
          throwsA(anything),
        );
      },
    );
  });

  group('collectFields', () {
    for (var target in $fstateTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, _, __) async {
          final classs = library.findType(target.className)!;
          final actual = collectFields(classs);
          expectObjectJson(
            actual,
            target.expected.fields,
          );
        },
      );
    }
  });
}
