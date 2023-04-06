import 'package:fstate_generator/src/helpers/key_generator.dart';
import 'package:fstate_generator/src/helpers/parameter.dart';
import 'package:test/test.dart';

import '../dart_format_extension.dart';

void main() {
  group('Key generator', () {
    test('can generate constructor', () {
      final targets = [
        FstateKeyGenerator(
          baseName: 'Counter',
          params: [
            Parameter(
              type: 'Function',
              name: 'constructor',
              defaultValue: 'Counter.new',
            ),
          ],
          stateType: 'Counter',
        ),
        FstateKeyGenerator(
          baseName: 'debouncedCount',
          stateType: 'int',
          params: [
            Parameter(
              type: 'Function',
              name: 'debouncedCount',
              defaultValue: 'debouncedCount',
            ),
          ],
        ),
      ];
      final expected = [
        r'''class _CounterKey extends FstateKey{
          _CounterKey({
            Function constructor = Counter.new
          }):super(Counter, [constructor]);
        }''',
        r'''class _DebouncedCountKey extends FstateKey {
          _DebouncedCountKey({
            Function debouncedCount = debouncedCount
          }):super(int, [debouncedCount]);
        }''',
      ];

      for (var i = 0; i < targets.length; i++) {
        final target = targets[i];
        final actual = target.toString();
        expect(actual.format(), expected[i].format());
      }
    });
  });
}
