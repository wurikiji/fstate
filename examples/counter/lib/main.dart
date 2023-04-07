import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

import 'counter.dart';

part 'main.g.dart';

void main() {
  runApp(const FstateScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: $CounterWidget(),
    );
  }
}

@Fwidget()
class CounterWidget extends StatelessWidget {
  @Fconstructor()
  const CounterWidget({
    @Finject() required this.counter,
    super.key,
  });

  final Counter counter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You clicked"),
            Text(
              '${counter.count}',
              style: const TextStyle(fontSize: 32),
            ),
            const Text("Times"),
            const SizedBox(height: 32),
            const Text("This is a throttled counter"),
            const $ThrottledCounterWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.count++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

Stream throttleOnceASecond(Stream stream) {
  return stream.throttleTime(const Duration(seconds: 1));
}

@Fselector()
int countSelector(
  @Finject(
    alternator: throttleOnceASecond,
  )
      Counter counter,
) {
  return counter.count;
}

@Fwidget()
class ThrottledCounterWidget extends StatelessWidget {
  @Fconstructor()
  const ThrottledCounterWidget({
    @Finject(derivedFrom: countSelector) required this.count,
    super.key,
  });
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count',
      style: const TextStyle(fontSize: 32),
    );
  }
}
