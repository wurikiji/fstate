import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

abstract class FstateWidget extends StatefulWidget {
  const FstateWidget({super.key});

  List<Param> get $params => [];

  Map<dynamic, FTransformer> get $transformers => {};

  Function get $widgetBuilder;

  Widget Function(BuildContext)? get $onLoading;

  Widget Function(BuildContext, Object? error)? get $onError;

  @override
  State<FstateWidget> createState() => _FstateWidgetState();
}

class _FstateWidgetState extends State<FstateWidget> {
  FstateStreamContainer? container;
  late Stream refreshStream;
  bool _needUnregister = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final oldContainer = container;
    container = FstateScope.containerOf(context);
    if (oldContainer == null) {
      refreshStream = _buildStream();
      return;
    }
    if (container != oldContainer) {
      _needUnregister = false;
      refreshStream = _buildStream();
      _unregisterDepdencies(oldContainer, widget.$params, true);
    }
  }

  @override
  void didUpdateWidget(covariant FstateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.$params != oldWidget.$params) {
      refreshStream = _buildStream();
    }
  }

  @override
  void dispose() {
    _unregisterDepdencies(container!, widget.$params);
    super.dispose();
  }

  Stream _buildStream() {
    final deps = widget.$params.where((e) => e.value is FstateFactory);
    if (deps.isEmpty) {
      return Stream.value(0);
    }
    final builtDeps = deps.map(
      (e) => calculateFstateFactoryParam(
        container!,
        e,
        <V>(key, V value) {
          return (e is NamedParam)
              ? Param.named(key, value)
              : Param.positional(key, value);
        },
      ),
    );
    _unregisterDepdencies(container!, widget.$params);
    _needUnregister = true;

    return BehaviorSubject()
      ..addStream(CombineLatestStream.list(builtDeps.map((e) {
        final transformer = widget.$transformers[e.key];
        return applyTransformer(e.value, transformer);
      })));
  }

  @override
  Widget build(BuildContext context) {
    final manualInputs =
        widget.$params.where((e) => e.value is! FstateFactory).toList();
    return StreamBuilder(
      stream: refreshStream.distinctUnique(),
      builder: (context, deps) {
        if (deps.hasError) {
          return widget.$onError?.call(context, deps.error) ??
              Text(
                deps.error.toString(),
                style: const TextStyle(color: Colors.red),
              );
        }
        if (!deps.hasData) {
          return widget.$onLoading?.call(context) ?? const SizedBox.shrink();
        }
        return _constructWidget([
          ...manualInputs,
          ...(deps.data!.whereType<Param>()),
        ]);
      },
    );
  }

  void _unregisterDepdencies(
      FstateStreamContainer container, List<Param> params,
      [bool force = false]) {
    if (!_needUnregister && !force) return;
    final deps = params
        .where((e) => e.value is FstateFactory)
        .map((e) => e.value as FstateFactory);
    for (final dep in deps) {
      dep.unregister(container);
    }
    _needUnregister = false;
  }

  Widget _constructWidget(List<Param> params) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    return Function.apply(widget.$widgetBuilder, positionalParams, namedParams)
        as Widget;
  }
}
