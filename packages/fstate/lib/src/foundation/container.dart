import 'dart:async';
import 'dart:collection';

class FstateContainer {
  FstateContainer();

  final HashMap<Object, StreamController<Object>> _controllers = HashMap();
  final HashMap<Object, dynamic> _store = HashMap();

  void put<T>(Object key, T value) {
    _store[key] = value;
    _notifyListeners(key);
  }

  T? get<T>(Object key) {
    return _store[key] as T?;
  }

  void delete<T>(Object key) {
    _store.remove(key);
  }

  void _notifyListeners(Object key) {
    _controllers[key]?.add(get(key));
  }

  Stream<T> stream<T>(Object key) {
    _controllers[key] ??= StreamController.broadcast();
    return _controllers[key]!.stream as Stream<T>;
  }

  bool contains(Object key) {
    return _store.containsKey(key);
  }
}
