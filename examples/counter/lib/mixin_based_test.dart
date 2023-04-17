import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  runApp(const FstateScope(child: MaterialApp(home: AAA())));
}

class FstateNullWidget extends StatelessWidget {
  const FstateNullWidget({super.key});

  @override
  Widget build(BuildContext context) {
    throw 'This widget should not be built.';
  }
}

class Counter {
  const Counter(this.value, this.s);
  final BehaviorSubject<Counter> s;
  final int value;

  increment() {
    s.add(Counter(value + 1, s));
  }
}

mixin $Counter {
  static final _containers = <int, FstateStreamContainer>{};
  static final _elements = <int, Element>{};
  static final _subs = <int, Set<StreamSubscription>>{};

  List get counterEffects => [];

  Stream<Counter> Function(Stream<Counter> source)? get counterTransformer =>
      null;

  Counter counter() {
    final container = _containers[hashCode];
    if (container == null) {
      throw '''Counter Not Found: You must call [super.build] at the beggining of your [$runtimeType]'s build method.''';
    }
    final element = _elements[hashCode]!;
    final key = FstateKey('Counter', []);
    var counterSubject = container.get<Counter>(key);
    if (counterSubject == null) {
      counterSubject = BehaviorSubject<Counter>();
      final first = Counter(0, counterSubject);
      counterSubject.add(first);
      container.put(key, counterSubject);
    }

    _subs[hashCode] ??= {};
    final current = counterSubject.value;

    final sub = counterSubject.skip(1).listen((event) {
      // print('Got event: ${event.value}');
      try {
        // ignore: unnecessary_null_comparison
        if (element.widget != null) {
          element.markNeedsBuild();
        }
      } catch (e) {
        _subs[hashCode]?.forEach((element) {
          element.cancel();
        });
        _subs.remove(hashCode);
        _containers.remove(hashCode);
        _elements.remove(hashCode);
      }
    });
    _subs[hashCode]!.add(sub);

    return current;
  }

  inject(BuildContext context);

  /// A hacky way to inject a dependency.
  /// You must call [super.build] at the beggining of your widget's build method.
  /// You should not use the returned widget from this method.
  @mustCallSuper
  Widget build(BuildContext context) {
    inject(context);
    return const FstateNullWidget();
  }

  @override
  noSuchMethod(invocation) {
    final Element element = invocation.positionalArguments.first;
    final container = FstateScope.containerOf(element);

    _containers[hashCode] = container;
    _elements[hashCode] = element;

    _subs[hashCode]?.forEach((element) {
      element.cancel();
    });

    _subs[hashCode]?.clear();

    try {
      super.noSuchMethod(invocation);
    } catch (e) {
      ///
    }
  }
}

class CounterWidget extends FstateWidget with $Counter {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('${counter().value}');
  }
}

class AAA extends StatelessWidget with $Counter {
  const AAA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You clicked counter2"),
            Text(
              '${counter2.value}',
              style: const TextStyle(fontSize: 32),
            ),
            const Text("Times"),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'Nav',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AAA()),
            ),
            child: const Icon(Icons.forward),
          ),
          FloatingActionButton(
            onPressed: () => counter2.increment(),
            child: const Icon(Icons.looks_two),
          ),
        ],
      ),
    );
  }
}

something() async* {}

extension Counter2 on Widget {
  static final _subs = <Element, StreamSubscription>{};
  Counter useCounter(BuildContext context) {
    final element = context as Element;
    final container = FstateScope.containerOf(context);
    final key = FstateKey('Counter', []);
    var counterSubject = container.get<Counter>(key);
    if (counterSubject == null) {
      counterSubject = BehaviorSubject<Counter>();
      final first = Counter(0, counterSubject);
      counterSubject.add(first);
      container.put(key, counterSubject);
    }
    _subs[element]?.cancel();
    _subs[element] = counterSubject.skip(1).listen((event) {
      // print('Got event: ${event.value}');
      try {
        // ignore: unnecessary_null_comparison
        if (element.widget != null) {
          element.markNeedsBuild();
        }
      } catch (e) {
        _subs[element]?.cancel();
        _subs.remove(element);
      }
    });
    return counterSubject.value;
  }
}
