import 'package:fstate_generator/src/collector/helpers/param.dart';
import 'package:test/test.dart';

import '../../../test_utils/json_comparison.dart';
import '../../../test_utils/resolver.dart';
import 'test_data/constructor_test_data.dart';

void main() {
  group('collectParams', () {
    for (int i = 0; i < $classData.length; ++i) {
      final testName = $classData[i].test;
      final source = $classData[i].source;
      testWithLibraryReader('- $testName', source, (lib, _, __) async {
        final constructor = lib.findType('Counter')!.constructors.first;

        final parsed = collectParams(constructor);

        expectObjectJson(parsed, $classData[i].expected.params);
      });
    }
  });
}
