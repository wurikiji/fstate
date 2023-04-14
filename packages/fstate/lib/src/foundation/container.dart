import 'dart:collection';

import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

/// A simple hash map to store fstate streams.
class FstateStreamContainer {
  FstateStreamContainer();

  final HashMap<FstateKey, BehaviorSubject<dynamic>> _store = HashMap();

  BehaviorSubject<T> put<T>(FstateKey key, BehaviorSubject<T> newValue) {
    _store[key] = newValue;
    return get(key)!;
  }

  BehaviorSubject<T>? get<T>(FstateKey key) {
    return _store[key] as BehaviorSubject<T>?;
  }

  void delete(FstateKey key) {
    _store.remove(key);
  }

  bool contains(FstateKey key) {
    return _store.containsKey(key);
  }
}
