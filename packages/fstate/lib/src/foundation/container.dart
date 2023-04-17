import 'dart:collection';

import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

/// A simple hash map to store fstate streams.
class FstateStreamContainer {
  FstateStreamContainer();

  final HashMap<FstateKey, BehaviorSubject<dynamic>> _store = HashMap();
  final HashMap<FstateKey, int> _referenceCounter = HashMap();
  final HashSet<FstateKey> _keepAlive = HashSet();

  BehaviorSubject<T> put<T>(FstateKey key, BehaviorSubject<T> newValue,
      {bool keepAlive = false}) {
    _store[key] = newValue;
    if (keepAlive) {
      _keepAlive.add(key);
    }
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

    assert(count != 0, 'Unregistering $key that is not registered');

    if (count == 1 && !_keepAlive.contains(key)) {
      delete(key);
      return;
    }

    _referenceCounter[key] = count - 1;

    assert(_referenceCounter[key]! >= 0, 'Reference counter is negative');
  }

  void delete(FstateKey key) {
    final subject = _store[key];
    assert(subject != null, 'Deleting $key that is not in the container');
    _referenceCounter.remove(key);
    subject!.close();
    _store.remove(key);
  }

  bool contains(FstateKey key) {
    return _store.containsKey(key);
  }
}
