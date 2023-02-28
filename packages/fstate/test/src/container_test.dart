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
      void reRegister() {
        container.register(1);
      }

      expect(reRegister, throwsA(isA<FContainerException>()));
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
        container.register(first);
        final callback = createCallback(second);
        container.listen(first.runtimeType, callback);
        final callback2 = createCallback(second);
        container.listen(first.runtimeType, callback2);
      }

      for (final ex in examples) {
        final second = ex[1];
        container.update(second);
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
        container.register(first);
        final callback = createCallback(second);
        final subs = container.listen(first.runtimeType, callback);
        subs.cancel();
      }

      for (final ex in examples) {
        final second = ex[1];
        container.update(second);
      }
    });
  });
}
