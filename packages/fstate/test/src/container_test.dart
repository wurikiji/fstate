import 'package:fstate/src/container.dart';
import 'package:test/test.dart';

class Dummy {}

void main() {
  group('FContainer', () {
    final container = FContainer();
    test('can register anything', () async {
      final deps = [10, 'string', 1.1, Dummy()];
      for (final dep in deps) {
        container.register(dep);
      }

      for (final dep in deps) {
        final type = dep.runtimeType;
        final found = container.find(type);
        expect(found, dep);
      }
    });
  });
}
