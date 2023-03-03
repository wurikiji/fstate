import 'container.dart';

class FstateKey<T> {
  const FstateKey({
    required Function builder,
    this.namedInputs = const {},
    this.positionalInputs = const [],
  }) : _builder = builder;

  final Function _builder;
  final Map<Symbol, dynamic> namedInputs;
  final List<PositionalParam> positionalInputs;

  Map<Symbol, dynamic> get additionalNamedInputs => {};
  List<PositionalParam> get additionalPositionalInputs => [];

  T build(FstateContainer container) {
    final additionalNamedInputs = _calculateAdditionalNamedInputs(container);
    final additionalPositionalInputs =
        _calculateAdditionalPositionalInputs(container);
    return Function.apply(
      _builder,
      ([
        ...positionalInputs,
        ...additionalPositionalInputs,
      ]..sort((a, b) => a.index.compareTo(b.index)))
          .map((e) => e.value)
          .toList(),
      {
        ...namedInputs,
        ...additionalNamedInputs,
      },
    );
  }

  Map<Symbol, dynamic> _calculateAdditionalNamedInputs(
      FstateContainer container) {
    final fstateKeyEntries = additionalNamedInputs.entries
        .where((element) => element.value is FstateKey)
        .map((e) {
      final value = container.get(e.value);
      return MapEntry(e.key, value);
    });

    final functionEntries = additionalNamedInputs.entries
        .where((e) => e.value is Function)
        .map((e) {
      final value = () {
        try {
          return e.value();
        } catch (_) {
          return e.value(container);
        }
      }();
      return MapEntry(e.key, value);
    });
    return Map.fromEntries(fstateKeyEntries)..addEntries(functionEntries);
  }

  List<PositionalParam> _calculateAdditionalPositionalInputs(
      FstateContainer container) {
    final fstateKeyEntries = additionalPositionalInputs
        .where((element) => element.value is FstateKey)
        .map((e) {
      final value = container.get(e.value);
      return PositionalParam(index: e.index, value: value);
    });
    final functionEntries =
        additionalPositionalInputs.where((e) => e.value is Function).map((e) {
      final value = () {
        try {
          return e.value();
        } catch (_) {
          return e.value(container);
        }
      }();
      return PositionalParam(index: e.index, value: value);
    });
    return [...fstateKeyEntries, ...functionEntries];
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other is FstateKey &&
            areTwoListsSame(positionalInputs, other.positionalInputs) &&
            areTwoMapsSame(namedInputs, other.namedInputs) &&
            _builder == other._builder);
  }

  @override
  int get hashCode => Object.hashAllUnordered([
        ...positionalInputs,
        ...namedInputs.keys,
        ...namedInputs.values,
        _builder,
      ]);
}

class FstateKeyFamily<T> {
  const FstateKeyFamily();

  FstateKey<T> buildKey(
    List<PositionalParam> positionalArguments,
    Map<Symbol, dynamic> namedArguments,
  ) {
    return Function.apply(
      FstateKey<T>.new,
      positionalArguments,
      namedArguments,
    );
  }
}

class PositionalParam<T> {
  PositionalParam({
    required this.index,
    required this.value,
  });
  final int index;
  final T value;

  @override
  int get hashCode => Object.hash(index, value);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PositionalParam &&
            index == other.index &&
            value == other.value);
  }
}

bool areTwoMapsSame(Map map1, Map map2) {
  if (map1.length != map2.length) return false;
  for (final key in map1.keys) {
    if (map1[key] != map2[key]) return false;
  }
  return true;
}

bool areTwoListsSame(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) return false;
  for (var i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}
