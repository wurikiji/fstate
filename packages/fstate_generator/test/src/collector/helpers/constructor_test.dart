import 'package:fstate_generator/src/collector/helpers/constructor.dart';
import 'package:test/test.dart';

import '../../../test_utils/json_comparison.dart';
import '../../../test_utils/resolver.dart';
import 'test_data/constructor_test_data.dart';

void main() {
  final targets = $classData;
  group('parseConstructor', () {
    for (int i = 0; i < targets.length; ++i) {
      final testName = targets[i].test;
      final source = targets[i].source;
      testWithLibraryReader('- $testName', source, (lib, _, __) async {
        final constructor = lib.findType('Counter')!.constructors.first;

        final parsed = parseConstructor(constructor);

        expectObjectJson(parsed, targets[i].expected);
      });
    }
  });
}
