// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class $CounterWidget extends FstateWidget {
  const $CounterWidget({
    super.key,
  });

  @override
  Function get widgetBuilder => CounterWidget.new;

  @override
  List<Param> get params => [Param.named(#counter, $Counter())];

  @override
  Map<dynamic, Alternator> get alternators => {};
}

class $ThrottledCounterWidget extends FstateWidget {
  const $ThrottledCounterWidget({
    super.key,
  });

  @override
  Function get widgetBuilder => ThrottledCounterWidget.new;

  @override
  List<Param> get params => [Param.named(#count, $CountSelector())];

  @override
  Map<dynamic, Alternator> get alternators => {};
}

// **************************************************************************
// SelectorGenerator
// **************************************************************************

class _CountSelectorKey extends FstateKey {
  _CountSelectorKey({Function countSelector = countSelector})
      : super(int, [countSelector]);
}

int _countSelector({$setNextState, required Counter counter}) => countSelector(
      counter,
    );

class $CountSelector extends FstateFactory<int> {
  $CountSelector() : stateKey = _CountSelectorKey();

  @override
  final FstateKey stateKey;

  @override
  Function get stateBuilder => _countSelector;

  @override
  List<Param> get params => [Param.named(#counter, $Counter())];

  @override
  Map<dynamic, Alternator> get alternators => {#counter: throttleOnceASecond};
}
