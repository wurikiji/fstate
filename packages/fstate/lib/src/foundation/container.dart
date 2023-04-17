import 'dart:collection';

import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

/// A simple hash map to store fstate streams.
class FstateStreamContainer {
  FstateStreamContainer();

  final HashMap<FstateKey, BehaviorSubject<dynamic>> _store = HashMap();
  final HashMap<FstateKey, int> _referenceCounter = HashMap();

  BehaviorSubject<T> put<T>(FstateKey key, BehaviorSubject<T> newValue) {
    _store[key] = newValue;
    return get(key)!;
  }

  BehaviorSubject<T>? get<T>(FstateKey key) {
    register(key);
    return _store[key] as BehaviorSubject<T>?;
  }

  void register(FstateKey key) {
    _referenceCounter[key] = (_referenceCounter[key] ?? 0) + 1;
  }

  void unregister(FstateKey key) {
    final count = _referenceCounter[key] ?? 0;

    if (count == 0) {
      throw Exception('Unregistering $key that is not registered');
    }

    if (count == 1) {
      _referenceCounter.remove(key);
      delete(key);
    } else {
      _referenceCounter[key] = count - 1;
    }
  }

  void delete(FstateKey key) {
    _store.remove(key);
  }

  bool contains(FstateKey key) {
    return _store.containsKey(key);
  }
}
