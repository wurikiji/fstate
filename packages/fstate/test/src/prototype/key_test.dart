import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

void main() {
  late FstateContainer container;
  setUp(() {
    container = FstateContainer();
    container.put('int', 1);
  });
  group('FstateKey', () {
    test('has a builder ', () {
      final key = FstateKey<int>(builder: () => 1);
      final value = key.build(container);
      expect(value, equals(1));
    });

    test("can inject inputs to the builder's closure", () {
      final key = FstateKey<int>(
        builder: (int i) => i,
      );
      final value = key.build(container);
      expect(value, equals(1));
    });
  });

  group('FstateKeyFamily', () {
    test('is a function returning FstateKey', () {
      final family = FstateKeyFamily<int>(builder: () => 1);
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
  });
}

class OneArgumentFamily<T> {
  OneArgumentFamily({
    required Function builder,
  }) : _builder = builder;
  final Function _builder;

  InjectedFstateKey<T> call(int i) {
    return noSuchMethod(Invocation.method(
      #fstate,
      [],
      {
        #builder: _builder,
        #positionalInputs: [i],
      },
    ));
  }

  @override
  noSuchMethod(Invocation invocation) {
    final positionalParams = invocation.positionalArguments;
    final namedParams = invocation.namedArguments;
    return Function.apply(
      InjectedFstateKey<T>.new,
      positionalParams,
      namedParams,
    );
  }
}

class FstateKeyFamily<T> {
  const FstateKeyFamily({
    required Function builder,
  }) : _builder = builder;

  final Function _builder;

  FstateKey<T> call() {
    return noSuchMethod(Invocation.method(#fstate, [], {#builder: _builder}));
  }

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

class InjectedFstateKey<T> {
  const InjectedFstateKey({
    required Function builder,
    Map<Symbol, dynamic> namedInputs = const {},
    List<dynamic> positionalInputs = const [],
  })  : _namedInputs = namedInputs,
        _positionalInputs = positionalInputs,
        _builder = builder;

  final Map<Symbol, dynamic> _namedInputs;
  final List<dynamic> _positionalInputs;

  final Function _builder;

  T build(FstateContainer container) {
    return Function.apply(
      _builder,
      _positionalInputs,
      _namedInputs,
    );
  }
}

class FstateKey<T> {
  const FstateKey({
    required Function builder,
    Map<Symbol, dynamic> inputs = const {},
  })  : _inputs = inputs,
        _builder = builder;

  final Map<Symbol, dynamic> _inputs;

  final Function _builder;

  T build(FstateContainer container) {
    final int value = container.get('int');
    return Function.apply(
        _builder,
        [
          if (_builder.runtimeType.toString().contains('(int)')) value,
        ],
        _inputs);
  }
}
