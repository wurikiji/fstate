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

  final HashMap<Type, StreamController<Object>> _streams = HashMap();

  @override
  void put(target) {
    super.put(target);
    _notifyListeners(target);
  }

  void _notifyListeners(dynamic target) {
    final type = target.runtimeType;
    _streams[type]?.add(target);
  }

  @override
  StreamSubscription<T> listen<T>(
    Type type,
    void Function(T nextValue) callback,
  ) {
    final controller = _streams[type] ??= StreamController<Object>.broadcast();
    return (controller.stream.listen(callback as void Function(Object))
        as StreamSubscription<T>);
  }
}

abstract class FContainer {
  FContainer._();
  factory FContainer() = _FContainerWithStreamController;
  final HashMap<Object, dynamic> _store = HashMap();
  void put(Object value) {
    final key = value.runtimeType;
    _store[key] = value;
  }

  T get<T>([Type? key]) {
    if (!_contains(key ?? T)) {
      throw FContainerException('You should [put] type "${key ?? T}" first.');
    }
    return _store[key ?? T];
  }

  void delete<T>([Type? key]) {
    _store.remove(key ?? T);
  }

  StreamSubscription<T> listen<T>(
    Type type,
    void Function(T nextValue) callback,
  );

  bool _contains(Object key) {
    return _store.containsKey(key);
  }
}
