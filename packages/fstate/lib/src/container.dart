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
  void update(target) {
    super.update(target);
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
  void register(dynamic target) {
    final type = target.runtimeType;
    if (_isRegistered(type)) {
      throw FContainerException(
        'Type [$type] is already registered.'
        ' Use [update] to overwrite type [$type].',
      );
    }
    _store[type] = target;
  }

  T find<T>([Type? type]) {
    return _store[type ?? T];
  }

  void update(dynamic target) {
    final type = target.runtimeType;
    if (!_isRegistered(type)) {
      throw FContainerException(
        'Type [$type] is not registered yet.'
        'You shoulde call [register] first.',
      );
    }
    _store[type] = target;
  }

  bool _isRegistered(Type type) {
    return _store.containsKey(type);
  }

  StreamSubscription<T> listen<T>(
    Type type,
    void Function(T nextValue) callback,
  );
}
