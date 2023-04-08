// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';
import 'package:rxdart/rxdart.dart';

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
    return Counter(value - 1);
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
      const widget =
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
          children: const [
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
          children: const [
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

      await tester.pumpAndSettle(const Duration(milliseconds: 1200));
      final debounced = find.text('1');
      expect(debounced, findsOneWidget);
    });
  });
}

/// Extended state

class _Counter implements Counter {
  _Counter({
    required this.setNextState,
    int value = 0,
  }) : _counter = Counter(value);

  _Counter.from({
    required this.setNextState,
    required Counter counter,
  }) : _counter = counter;

  final void Function(Counter) setNextState;
  final Counter _counter;

  @override
  int get value => _counter.value;

  @override
  set value(newValue) {
    _counter.value = newValue;
    setNextState(_Counter.from(setNextState: setNextState, counter: _counter));
  }

  @override
  void increment() {
    _counter.increment();
    setNextState(_Counter.from(setNextState: setNextState, counter: _counter));
  }

  @override
  Counter decrement() {
    final result = _counter.decrement();
    setNextState(
      _Counter.from(setNextState: setNextState, counter: result),
    );
    return result;
  }

  @override
  int multiply(int multiplier) {
    final result = _counter.multiply(multiplier);
    setNextState(
      _Counter.from(setNextState: setNextState, counter: _counter),
    );
    return result;
  }
}

class $Counter extends FstateFactory {
  $Counter({
    this.value = 0,
  }) : stateKey = _CounterKey(
          value: value,
        );
  final int value;

  @override
  final FstateKey stateKey;

  @override
  List<Param> get params => [
        Param.named(#value, value),
      ];

  @override
  Function get stateBuilder => _Counter.new;
}

class _CounterKey extends FstateKey {
  _CounterKey({
    int value = 0,
  }) : super(Counter, [Counter.new, value]);
}

/// State builder
class $InjectedCounterWidget extends FstateWidget {
  const $InjectedCounterWidget({super.key});

  @override
  List<Param> get params => [
        Param.named(#counter, $Counter()),
      ];

  @override
  Function get widgetBuilder => InjectedCounterWidget.new;
}

class $CounterWidget extends FstateWidget {
  const $CounterWidget({super.key});

  @override
  List<Param> get params => [
        Param.named(#count, $CountSelector()),
      ];

  @override
  Function get widgetBuilder => CounterWidget.new;
}

class $CounterIncreaser extends FstateWidget {
  const $CounterIncreaser({super.key});

  @override
  List<Param> get params => [
        Param.named(#increaseCounter, $IncreaseSelector()),
      ];

  @override
  Function get widgetBuilder => CounterIncreaser.new;
}

_countSelector({
  required Counter counter,
  setNextState,
}) =>
    countSelector(counter);

class $CountSelector extends FstateFactory {
  $CountSelector() : stateKey = _CountSelectorKey();

  @override
  List<Param> get params => [
        Param.named(#counter, $Counter()),
      ];

  @override
  Function get stateBuilder => _countSelector;

  @override
  final FstateKey stateKey;
}

class _CountSelectorKey extends FstateKey {
  _CountSelectorKey() : super(int, [countSelector]);
}

class $IncreaseSelector extends FstateFactory {
  $IncreaseSelector() : stateKey = _IncreaseSelectorKey();

  @override
  List<Param> get params => [
        Param.named(#counter, $Counter()),
      ];

  @override
  Function get stateBuilder => ({
        required Counter counter,
        setNextState,
      }) {
        return increaseSelector(counter);
      };

  @override
  final FstateKey stateKey;
}

class _IncreaseSelectorKey extends FstateKey {
  _IncreaseSelectorKey() : super(Function, [increaseSelector]);
}

class $DebouncedCount extends FstateFactory {
  $DebouncedCount() : stateKey = _DebouncedCountKey();

  @override
  List<Param> get params => [
        Param.named(#counter, $Counter()),
      ];

  @override
  Function get stateBuilder => ({
        required Counter counter,
        setNextState,
      }) {
        return debouncedCount(counter);
      };

  @override
  final FstateKey stateKey;

  @override
  Map<dynamic, Alternator> get alternators => {
        #counter: debounceOneSecond,
      };
}

class _DebouncedCountKey extends FstateKey {
  _DebouncedCountKey() : super(int, [debouncedCount]);
}

class $DebouncedCounterWidget extends FstateWidget {
  const $DebouncedCounterWidget({
    super.key,
  });
  @override
  Function get widgetBuilder => DebouncedCounterWidget.new;

  @override
  List<Param> get params => [
        Param.named(#count, $DebouncedCount()),
      ];
}
