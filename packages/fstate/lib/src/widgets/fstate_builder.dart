import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

abstract class FstateWidget extends StatelessWidget {
  const FstateWidget({super.key});

  List<Param> get params => [];
  Map<dynamic, Alternator> get alternators => {};
  Function get widgetBuilder;

  @override
  Widget build(BuildContext context) {
    final manualInputs = params.where((e) => e.value is! FstateFactory);
    final deps = params.where((e) => e.value is FstateFactory);
    if (deps.isEmpty) {
      return _constructWidget(manualInputs);
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

    final refreshStream = CombineLatestStream.list<Param>(builtDeps.map((e) {
      final alternator = alternators[e.key];
      return applyAlternator(e.value, alternator) as Stream<Param>;
    }));

    return StreamBuilder(
      stream: refreshStream,
      builder: (context, deps) {
        if (!deps.hasData) {
          return const SizedBox.shrink();
        }
        return _constructWidget([
          ...manualInputs,
          ...deps.data as Iterable<Param>,
        ]);
      },
    );
  }

  Widget _constructWidget(Iterable<Param> params) {
    final positionalParams = convertToPositionalParams(params).toList();
    final namedParams = convertToNamedParams(params);
    return Function.apply(widgetBuilder, positionalParams, namedParams)
        as Widget;
  }
}

class FstateConsumer<T> extends StatelessWidget {
  const FstateConsumer({
    required this.fstate,
    required this.builder,
    super.key,
  });

  final FstateFactory<T> fstate;
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
