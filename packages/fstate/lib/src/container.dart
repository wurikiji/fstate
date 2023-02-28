import 'dart:async';

class FContainerException implements Exception {
  const FContainerException(this.message);
  final String message;
  @override
  String toString() {
    return 'FContainer throws: $message';
  }
}

class FContainer {
  final Map<Type, dynamic> _store = {};
  void register(dynamic target) {
    final type = target.runtimeType;
    if (_store[type] != null) {
      throw FContainerException(
        'Type [$type] is already registered.'
        ' Use [update] to overwrite type [$type].',
      );
    }
    _store[type] = target;
    _streams[type] = StreamController<Object>.broadcast();
  }

  T find<T>([Type? type]) {
    return _store[type ?? T];
  }

  void update(dynamic target) {
    final type = target.runtimeType;
    if (_store[type] == null) {
      throw FContainerException(
        'Type [$type] is not registered yet.'
        'You shoulde call [register] first.',
      );
    }
    _store[type] = target;
    _streams[type]?.add(target);
  }

  final Map<Type, StreamController<Object>> _streams = {};

  StreamSubscription<T> listen<T>(
    Type type,
    void Function(T nextValue) callback,
  ) {
    return (_streams[type]!.stream.listen(callback as void Function(Object))
        as StreamSubscription<T>);
  }
}
