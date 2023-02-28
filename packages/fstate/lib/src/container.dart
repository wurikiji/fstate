import 'dart:async';
import 'dart:collection';

class FContainerException implements Exception {
  const FContainerException(this.message);
  final String message;

  // coverage:ignore-start
  @override
  String toString() {
    return 'FContainer throws: $message';
  }
  // coverage:ignore-end
}

class _FContainerWithStreamController extends FContainer {
  _FContainerWithStreamController() : super._();

  final HashMap<Object, StreamController<Object>> _streams = HashMap();

  @override
  void put<T>(key, value) {
    super.put(key, value);
    _notifyListeners(key);
  }

  void _notifyListeners(Object key) {
    _streams[key]?.add(get(key));
  }

  @override
  StreamSubscription<T> listen<T>(
    Object key,
    void Function(T nextValue) callback,
  ) {
    final controller = _streams[key] ??= StreamController<Object>.broadcast();
    return (controller.stream.listen(callback as void Function(Object))
        as StreamSubscription<T>);
  }
}

abstract class FContainer {
  FContainer._();
  factory FContainer() = _FContainerWithStreamController;
  final HashMap<Object, dynamic> _store = HashMap();
  void put<T>(Object key, T value) {
    _store[key] = value;
  }

  T get<T>(Object key) {
    if (!_contains(key)) {
      throw FContainerException('You should [put] type "$key " first.');
    }
    return _store[key] as T;
  }

  void delete<T>(Object key) {
    _store.remove(key);
  }

  StreamSubscription<T> listen<T>(
    Object key,
    void Function(T nextValue) callback,
  );

  bool _contains(Object key) {
    return _store.containsKey(key);
  }
}
