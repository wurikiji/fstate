// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

part 'injection_test.g.dart';

@Fstate()
class Counter {
  @Fconstructor()
  Counter([this.value = 0]);

  @Faction()
  int value;

  @Faction()
  void increment() {
    // impure function (side-effect)
    value++;
  }

  @Faction(returnsNextState: true)
  Counter decrement() {
    // pure function
    return Counter(--value);
  }

  @Faction()
  int multiply(int multiplier) {
    // impure function returns value
    return value * multiplier;
  }
}

@Fselector()
int countSelector(
  @Finject() Counter counter,
) =>
    counter.value;

@Fselector()
void Function() increaseSelector(
  @Finject() Counter counter,
) {
  return counter.increment;
}

Stream debounceOneSecond(Stream source) {
  return source.debounceTime(const Duration(milliseconds: 1000));
}

@Fselector()
int debouncedCount(
  @Finject(alternator: debounceOneSecond) Counter counter,
) =>
    counter.value;

@Fwidget()
class InjectedCounterWidget extends StatelessWidget {
  @Fconstructor()
  const InjectedCounterWidget({
    @Finject() required this.counter,
    super.key,
  });
  final Counter counter;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(counter.value.toString()),
        GestureDetector(
          onTap: () {
            counter.increment();
          },
          child: const Text("increase by one"),
        ),
      ],
    );
  }
}

@Fwidget()
class CounterWidget extends StatelessWidget {
  @Fconstructor()
  const CounterWidget({
    @Finject(from: countSelector) required this.count,
    super.key,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(count.toString());
  }
}

@Fwidget()
class CounterIncreaser extends StatelessWidget {
  final void Function() increaseCounter;

  @Fconstructor()
  const CounterIncreaser({
    @Finject(from: increaseSelector) required this.increaseCounter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => increaseCounter(),
      child: const Text('Increase by one'),
    );
  }
}

@Fwidget()
class DebouncedCounterWidget extends StatelessWidget {
  @Fconstructor()
  const DebouncedCounterWidget({
    @Finject(from: debouncedCount) required this.count,
    super.key,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(count.toString());
  }
}

void main() {
  group('Simple injectable state', () {
    testWidgets('can inject', (tester) async {
      final widget =
          FstateScope(child: MaterialApp(home: $InjectedCounterWidget()));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final text = find.text('0');
      expect(text, findsOneWidget);
      final button = find.byType(GestureDetector);

      await tester.tap(button);
      await tester.pumpAndSettle();

      final changed = find.text('1');
      expect(changed, findsOneWidget);
    });
    testWidgets('can use selector', (tester) async {
      final widget = FstateScope(
          child: MaterialApp(
        home: Column(
          children: [
            $CounterWidget(),
            $CounterIncreaser(),
          ],
        ),
      ));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final text = find.text('0');
      expect(text, findsOneWidget);

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final changed = find.text('1');
      expect(changed, findsOneWidget);
    });
    testWidgets('can alternate dependencies', (tester) async {
      final widget = FstateScope(
          child: MaterialApp(
        home: Column(
          children: [
            $DebouncedCounterWidget(),
            $CounterIncreaser(),
          ],
        ),
      ));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle(const Duration(milliseconds: 1200));

      final text = find.text('0');
      expect(text, findsOneWidget);

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final changed = find.text('0');
      expect(changed, findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.text('0'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(milliseconds: 1200));
      final debounced = find.text('1');
      expect(debounced, findsOneWidget);
    });
  });
}

/// Extended state
