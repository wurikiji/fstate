import 'dart:async';
import 'dart:collection';

class _FstateContainerWithStreamController extends FstateContainer {
  _FstateContainerWithStreamController() : super._();

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

abstract class FstateContainer {
  FstateContainer._();
  factory FstateContainer() = _FstateContainerWithStreamController;
  final HashMap<Object, dynamic> _store = HashMap();
  void put<T>(Object key, T value) {
    _store[key] = value;
  }

  T? get<T>(Object key) {
    return _store[key] as T?;
  }

  void delete<T>(Object key) {
    _store.remove(key);
  }

  StreamSubscription<T> listen<T>(
    Object key,
    void Function(T nextValue) callback,
  );

  bool contains(Object key) {
    return _store.containsKey(key);
  }
}
