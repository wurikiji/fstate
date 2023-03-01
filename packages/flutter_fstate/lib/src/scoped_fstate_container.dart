import 'package:flutter/material.dart';
import 'package:flutter_fstate/flutter_fstate.dart';

class FstateScope extends StatefulWidget {
  final Widget child;

  const FstateScope({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<FstateScope> createState() => _FstateScopeState();
}

class _FstateScopeState extends State<FstateScope> {
  final container = FstateContainer();

  @override
  Widget build(BuildContext context) {
    return ScopedFstateContainer(
      container: container,
      child: widget.child,
    );
  }
}

class ScopedFstateContainer extends InheritedWidget {
  final FstateContainer container;

  const ScopedFstateContainer({
    required super.child,
    required this.container,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant ScopedFstateContainer oldWidget) {
    return container != oldWidget.container;
  }
}
