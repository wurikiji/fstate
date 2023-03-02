import 'container.dart';

class FstateKey<T> {
  const FstateKey({
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

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other is FstateKey &&
            areTwoListsSame(_positionalInputs, other._positionalInputs) &&
            areTwoMapsSame(_namedInputs, other._namedInputs) &&
            _builder == other._builder);
  }

  @override
  int get hashCode => Object.hashAllUnordered([
        ..._positionalInputs,
        ..._namedInputs.keys,
        ..._namedInputs.values,
        _builder,
      ]);
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
