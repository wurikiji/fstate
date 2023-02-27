class FContainer {
  final Map<Type, dynamic> _store = {};
  void register(dynamic target) {
    _store[target.runtimeType] = target;
  }

  T find<T>([Type? type]) {
    return _store[type ?? T];
  }
}
