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

@fwidget
class CounterWidget extends StatelessWidget {
  const CounterWidget({
    @inject$Counter required this.counter,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Stream throttleOnceASecond(Stream stream) {
  return stream.throttleTime(const Duration(seconds: 1));
}
