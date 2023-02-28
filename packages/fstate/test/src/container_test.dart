@Timeout(Duration(milliseconds: 1000))
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
        container.put(dep);
      }

      for (final dep in deps) {
        final type = dep.runtimeType;
        final found = container.get(type);
        expect(found, dep);
      }
    });

    test('can update registered type', () {
      container.put(10);
      container.put(1);
      final int updated = container.get();
      expect(updated, 1);
    });

    test('should throw on getting non-registered type', () {
      expect(() => container.get<int>(), throwsA(isA<FContainerException>()));
    });

    test('can notify all listeners when update the target type', () {
      void Function(T next) createCallback<T>(T target) {
        return expectAsync1((T nextValue) {
          expect(nextValue, equals(target));
        });
      }

      final examples = [
        [1, 2],
        [1.1, 2.2],
        ['hello', 'hi'],
        [Dummy(), Dummy()]
      ];

      for (final ex in examples) {
        final first = ex[0];
        final second = ex[1];
        container.put(first);
        final callback = createCallback(second);
        container.listen(first.runtimeType, callback);
        // intentionally register two times to test if all listeners are called.
        final callback2 = createCallback(second);
        container.listen(first.runtimeType, callback2);
      }

      for (final ex in examples) {
        final second = ex[1];
        container.put(second);
      }
    });
    test('should not notify when the listener cancels the subscription', () {
      void Function(T next) createCallback<T>(T target) {
        return (T nextValue) {
          fail('Notification callback should not be called reach here');
        };
      }

      final examples = [
        [1, 2],
        [1.1, 2.2],
        ['hello', 'hi'],
        [Dummy(), Dummy()]
      ];

      for (final ex in examples) {
        final first = ex[0];
        final second = ex[1];
        container.put(first);
        final callback = createCallback(second);
        final subs = container.listen(first.runtimeType, callback);
        subs.cancel();
      }

      for (final ex in examples) {
        final second = ex[1];
        container.put(second);
      }
    });
  });
}
