import 'dart:async';
import 'dart:collection';

import 'package:fstate/fstate.dart';

class FstateContainer {
  FstateContainer();

  final HashMap<FstateKey, StreamController<Object>> _controllers = HashMap();
  final HashMap<FstateKey, dynamic> _store = HashMap();

  void put<T>(FstateKey<T> key, [T? newValue]) {
    final value = newValue ?? key.build(this);
    _store[key] = value;
    _notifyListeners(key);
  }

  T? get<T>(FstateKey<T> key) {
    return _store[key] as T?;
  }

  void delete(FstateKey key) {
    _store.remove(key);
  }

  void _notifyListeners(FstateKey key) {
    _controllers[key]?.add(get(key));
  }

  Stream<T> stream<T>(FstateKey<T> key) {
    _controllers[key] ??= StreamController.broadcast();
    return _controllers[key]!.stream as Stream<T>;
  }

  bool contains(FstateKey key) {
    return _store.containsKey(key);
  }
}

class ReadOnlyContainer {
  ReadOnlyContainer(this._origin);
  final FstateContainer _origin;
  T? get<T>(FstateKey<T> key) {
    return _origin.get(key);
  }
}
