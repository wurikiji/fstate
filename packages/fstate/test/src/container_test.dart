import 'package:fstate/src/container.dart';
import 'package:test/test.dart';

class Dummy {}

void main() {
  group('FContainer', () {
    late FstateContainer container;
    setUp(() {
      container = FstateContainer();
    });
    test('can put anything', () async {
      final deps = [10, 'string', 1.1, Dummy()];
      for (final dep in deps) {
        container.put(dep.runtimeType, dep);
      }

      for (final dep in deps) {
        final type = dep.runtimeType;
        final found = container.get(type);
        expect(found, dep);
      }
    });

    test('can update value', () {
      const key = 'key';
      container.put(key, 10);
      container.put(key, 1);
      final int updated = container.get(key);
      expect(updated, 1);
    });

    test('should throw on getting non-registered key', () {
      const key = 'nothing';
      final data = container.get(key);
      expect(
        data,
        isNull,
      );
    });

    test('can get stream of data', () {
      final examples = [
        ['first', 1, 2],
        ['second', 1.1, 2.2],
        ['third', 'hello', 'hi'],
        ['fourth', Dummy(), Dummy()]
      ];

      for (final ex in examples) {
        final key = ex[0];
        final first = ex[1];
        final second = ex[2];
        container.put(key, first);
        final Stream stream = container.stream(key);
        expect(stream, emits(second));
      }

      for (final ex in examples) {
        final key = ex[0];
        final second = ex[2];
        container.put(key, second);
      }
    });

    test('can delete items', () {
      const value = 10;
      const key = 'key';
      container.put(key, value);
      container.delete(key);
      final data = container.get(key);
      expect(
        data,
        isNull,
      );
    });

    test('can check if it contains the key', () {
      const key = 'key';
      container.put(key, 10);
      expect(container.contains(key), isTrue);
      container.delete(key);
      expect(container.contains(key), isFalse);
    });
  });
}
