import 'dart:async';
import 'dart:collection';

import 'package:fstate/fstate.dart';

/// A simple hash map to store fstate streams.
class FstateStreamContainer {
  FstateStreamContainer();

  final HashMap<FstateKey, Stream<dynamic>> _store = HashMap();

  Stream<T> put<T>(FstateKey key, Stream<T> newValue) {
    _store[key] = newValue;
    return get(key)!;
  }

  Stream<T>? get<T>(FstateKey key) {
    return _store[key] as Stream<T>?;
  }

  void delete(FstateKey key) {
    _store.remove(key);
  }

  bool contains(FstateKey key) {
    return _store.containsKey(key);
  }
}
