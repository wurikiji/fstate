import 'package:flutter/widgets.dart';

import '../foundation/container.dart';

class FstateScope extends StatefulWidget {
  final Widget child;

  const FstateScope({
    required this.child,
    Key? key,
  }) : super(key: key);

  static FstateContainer containerOf(BuildContext context) {
    final scoped =
        context.dependOnInheritedWidgetOfExactType<_ScopedFstateContainer>();

    if (scoped == null) {
      throw const FstateScopeException(
          'You should wrap your widget with FstateScope');
    }

    return scoped.container;
  }

  @override
  State<FstateScope> createState() => _FstateScopeState();
}

class _FstateScopeState extends State<FstateScope> {
  final container = FstateContainer();

  @override
  Widget build(BuildContext context) {
    return _ScopedFstateContainer(
      container: container,
      child: widget.child,
    );
  }
}

class _ScopedFstateContainer extends InheritedWidget {
  final FstateContainer container;

  const _ScopedFstateContainer({
    required super.child,
    required this.container,
  });

  @override
  bool updateShouldNotify(covariant _ScopedFstateContainer oldWidget) {
    return container != oldWidget.container;
  }
}

class FstateScopeException implements Exception {
  const FstateScopeException(this.message);
  final String message;
  @override
  String toString() => 'FstateScopeException: $message';
}
