import 'package:flutter/foundation.dart';
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
  bool needUnregister = false;
  List<Param> params = [];

  @override
  void initState() {
    super.initState();
    params = widget.$params;
  }

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
      _unregisterDepdencies(oldContainer, params, true);
      refreshStream = _buildStream();
    }
  }

  @override
  void didUpdateWidget(covariant FstateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(params, widget.$params)) {
      _unregisterDepdencies(container!, params);
      params = widget.$params;
      refreshStream = _buildStream();
    }
  }

  @override
  void dispose() {
    _unregisterDepdencies(container!, params);
    super.dispose();
  }

  Stream _buildStream() {
    final deps = params.where((e) => e.value is FstateFactory);
    if (deps.isEmpty) {
      return BehaviorSubject.seeded([]);
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
    _unregisterDepdencies(container!, params);
    needUnregister = true;

    return BehaviorSubject()
      ..addStream(CombineLatestStream.list(builtDeps.map((e) {
        final transformer = widget.$transformers[e.key];
        return applyTransformer(e.value, transformer);
      })));
  }

  @override
  Widget build(BuildContext context) {
    final manualInputs =
        params.where((e) => e.value is! FstateFactory).toList();
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
    if (!needUnregister && !force) return;
    final deps = params
        .where((e) => e.value is FstateFactory)
        .map((e) => e.value as FstateFactory);
    for (final dep in deps) {
      dep.unregister(container);
    }
    needUnregister = false;
  }

  Widget _constructWidget(List<Param> params) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    return Function.apply(widget.$widgetBuilder, positionalParams, namedParams)
        as Widget;
  }
}
