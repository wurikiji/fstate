import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';
import 'package:fstate/src/foundation/key.dart';

void main() {
  late FstateContainer container;
  setUp(() {
    container = FstateContainer();
  });

  group('FstateKey', () {
    test('has a builder ', () {
      final key = FstateKey<int>(builder: () => 1);
      final value = key.build(container);
      expect(value, equals(1));
    });
  });

  group('FstateKeyFamily', () {
    test('is a function returning FstateKey', () {
      final family = NoParamFstateKeyFamily<int>(builder: () => 1);
      final key = family();
      final value = key.build(container);
      expect(value, 1);
    });
    test('can inject manually', () {
      final family = OneArgumentFamily<int>(builder: (int i) => i);
      for (final input in [1, 2, 3, 4, 5]) {
        final key = family(input);
        final value = key.build(container);
        expect(value, input);
      }
    });
    test('creates a equal key for equal positional inputs', () {
      final family = OneArgumentFamily<int>(builder: (int i) => i);
      for (final input in [1, 2, 3, 4, 5]) {
        final key1 = family(input);
        final key2 = family(input);
        expect(key1, key2);
        final value = key1.build(container);
        container.put(key1, value);
        final got = container.get(key2);
        expect(got, value);
      }
    });
    test('creates a equal key for equal named inputs', () {
      final family = OnePositionalArgumentFamily<int>(
        builder: ({required int i}) => i,
      );
      for (final input in [1, 2, 3, 4, 5]) {
        final key1 = family(i: input);
        final key2 = family(i: input);
        expect(key1, key2);
        final value = key1.build(container);
        container.put(key1, value);
        final got = container.get(key2);
        expect(got, value);
      }
    });
  });
}

class OnePositionalArgumentFamily<T> extends FstateKeyFamily<T> {
  OnePositionalArgumentFamily({
    required Function builder,
  }) : _builder = builder;
  final Function _builder;

  FstateKey<T> call({required int i}) {
    return noSuchMethod(Invocation.method(
      #fstate,
      [],
      {
        #builder: _builder,
        #namedInputs: {#i: i},
      },
    ));
  }
}

class OneArgumentFamily<T> extends FstateKeyFamily<T> {
  OneArgumentFamily({
    required Function builder,
  }) : _builder = builder;
  final Function _builder;

  FstateKey<T> call(int i) {
    return noSuchMethod(Invocation.method(
      #fstate,
      [],
      {
        #builder: _builder,
        #positionalInputs: [i],
      },
    ));
  }
}

class NoParamFstateKeyFamily<T> extends FstateKeyFamily<T> {
  const NoParamFstateKeyFamily({
    required Function builder,
  }) : _builder = builder;

  final Function _builder;

  FstateKey<T> call() {
    return noSuchMethod(Invocation.method(#fstate, [], {#builder: _builder}));
  }
}

abstract class FstateKeyFamily<T> {
  const FstateKeyFamily();

  @override
  noSuchMethod(Invocation invocation) {
    final positionalParams = invocation.positionalArguments;
    final namedParams = invocation.namedArguments;
    return Function.apply(
      FstateKey<T>.new,
      positionalParams,
      namedParams,
    );
  }
}
