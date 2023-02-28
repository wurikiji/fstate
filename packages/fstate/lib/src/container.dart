import 'dart:async';
import 'dart:collection';

class FContainerException implements Exception {
  const FContainerException(this.message);
  final String message;
  @override
  String toString() {
    return 'FContainer throws: $message';
  }
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
  final Map<Type, dynamic> _store = {};
  void put(dynamic target) {
    final type = target.runtimeType;
    _store[type] = target;
  }

  T find<T>([Type? type]) {
    return _store[type ?? T];
  }

  StreamSubscription<T> listen<T>(
    Type type,
    void Function(T nextValue) callback,
  );
}
