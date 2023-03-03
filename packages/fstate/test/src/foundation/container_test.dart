import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

class Dummy {}

void main() {
  group('FContainer', () {
    late FstateContainer container;
    setUp(() {
      container = FstateContainer();
    });
    test('can put anything', () async {
      final deps = [() => 10, () => 'string', () => 1.1];
      for (final dep in deps) {
        final key = FstateKey(builder: dep);
        container.put(key);
      }

      for (final dep in deps) {
        final key = FstateKey(builder: dep);
        final found = container.get(key);
        expect(found, dep());
      }
    });

    test('can update value', () {
      final key = FstateKey(builder: () => 10);
      container.put(key);
      container.put(key, 1);
      final int updated = container.get(key);
      expect(updated, 1);
    });

    test('should return null on getting non-registered key', () {
      final key = FstateKey(builder: () => 1);
      final data = container.get(key);
      expect(
        data,
        isNull,
      );
    });

    test('can get stream of data', () {
      final examples = [
        [FstateKey(builder: () => 1), 2],
        [FstateKey(builder: () => 1.1), 2.2],
        [FstateKey(builder: () => 'hello'), 'hi'],
      ];

      for (final ex in examples) {
        final key = ex[0];
        final second = ex[1];
        container.put(key as FstateKey);
        final Stream stream = container.stream(key);
        expect(stream, emits(second));
      }

      for (final ex in examples) {
        final key = ex[0] as FstateKey;
        final second = ex[1];
        container.put(key, second);
      }
    });

    test('can delete items', () {
      final key = FstateKey(builder: () => 10);
      container.put(key);
      container.delete(key);
      final data = container.get(key);
      expect(
        data,
        isNull,
      );
    });

    test('can check if it contains the key', () {
      final key = FstateKey(builder: () => 10);
      container.put(key);
      expect(container.contains(key), isTrue);
      container.delete(key);
      expect(container.contains(key), isFalse);
    });
  });
}
