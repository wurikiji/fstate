import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

abstract class FstateWidget extends StatefulWidget {
  const FstateWidget({super.key});

  List<Param> get params => [];

  Map<dynamic, Alternator> get alternators => {};

  Function get widgetBuilder;

  @override
  State<FstateWidget> createState() => _FstateWidgetState();
}

class _FstateWidgetState extends State<FstateWidget> {
  late Widget child;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final manualInputs = widget.params.where((e) => e.value is! FstateFactory);
    final deps = widget.params.where((e) => e.value is FstateFactory);
    if (deps.isEmpty) {
      child = _constructWidget(manualInputs);
      return;
    }
    final container = FstateScope.containerOf(context);
    final builtDeps = deps.map(
      (e) => calculateFstateFactoryParam(
        container,
        e,
        <V>(key, V value) {
          return (e is NamedParam)
              ? Param.named(key, value)
              : Param.positional(key, value);
        },
      ),
    );

    final refreshStream = CombineLatestStream.list(builtDeps.map((e) {
      final alternator = widget.alternators[e.key];
      return applyAlternator(e.value, alternator);
    }));

    child = StreamBuilder(
      stream: refreshStream,
      builder: (context, deps) {
        if (!deps.hasData) {
          return const SizedBox.shrink();
        }
        return _constructWidget([
          ...manualInputs,
          ...(deps.data!.whereType<Param>()),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  Widget _constructWidget(Iterable<Param> params) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    return Function.apply(widget.widgetBuilder, positionalParams, namedParams)
        as Widget;
  }
}

class FstateConsumer<T> extends StatelessWidget {
  const FstateConsumer({
    required this.fstate,
    required this.builder,
    super.key,
  });

  final FstateFactory fstate;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    final container = FstateScope.containerOf(context);
    final stream = container.get(fstate.stateKey) ??
        container.put(
          fstate.stateKey,
          fstate.createStateStream(container),
        );

    return StreamBuilder(
      stream: stream,
      builder: (context, data) {
        if (!data.hasData) {
          return const SizedBox.shrink();
        }
        return builder(context, data.data as T);
      },
    );
  }
}
