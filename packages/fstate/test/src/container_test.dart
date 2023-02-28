import 'package:fstate/src/container.dart';
import 'package:test/test.dart';

class Dummy {}

void main() {
  group('FContainer', () {
    late FContainer container;
    setUp(() {
      container = FContainer();
    });
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

    test('can not register multiple times', () {
      container.register(10);
      expect(() => container.register(1), throwsA(isA<FContainerException>()));
    });

    test('can update registered type', () {
      container.register(10);
      container.update(1);
      final int updated = container.find();
      expect(updated, 1);
    });

    test('can not update non-registered type', () {
      void updateNonRegistered() {
        container.update(10);
      }

      expect(updateNonRegistered, throwsA(isA<FContainerException>()));
    });
  });
}
