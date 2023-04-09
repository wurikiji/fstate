final $stateGeneratorTestData = <StateGeneratorTestData>[
  StateGeneratorTestData(
    name: 'simple',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';
@Fstate()
class Counter {
  Counter.fofo();
  @fconstructor
  Counter();
}
''',
    expectedExtension: r'''
extension CounterToFstateExtension on Counter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Counter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  } 
}
''',
    expectedExtendedState: r'''
class _$Counter implements Counter {
  _$Counter({
    required this.$setNextState
  }) : _state = Counter.new();

  _$Counter.from(this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;
}
''',
    expectedFactory: r'''
class $Counter extends FstateFactory {
  $Counter() : $stateKey = FstateKey('Counter', [Counter.new]);

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedInjectAnnotation: r'''
const inject$Counter = Finject(Counter, true);
''',
  ),
  StateGeneratorTestData(
    name: 'with params',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';
@Fstate()
class Counter {
  Counter({
    required this.a,
    required this.b,
    required this.c,
  });
  final int a;
  final int b;
  int c;
}
''',
    expectedExtension: r'''
extension CounterToFstateExtension on Counter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Counter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  } 
}
''',
    expectedExtendedState: r'''
class _$Counter implements Counter {
  _$Counter({
    required this.$setNextState,
    required int a,
    required int b,
    required int c
  }) : _state = Counter.new(a: a, b: b, c: c);

  _$Counter.from(this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get a => _state.a;

  @override
  int get b => _state.b;

  @override
  int get c => _state.c;

  @override
  set c(newVal) => _state.c = newVal;
}
''',
    expectedFactory: r'''
class $Counter extends FstateFactory {
  $Counter({
    required this.a,
    required this.b,
    required this.c
  }) : $stateKey = FstateKey('Counter', [Counter.new, a, b, c]);

  final int a;
  final int b;
  final int c;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [
    Param.named(#a, a),
    Param.named(#b, b),
    Param.named(#c, c)
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedInjectAnnotation: r'''
const inject$Counter$ = Finject(Counter, false);
''',
  ),
  StateGeneratorTestData(
    name: 'with methods',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';
@Fstate()
class Counter {
  Counter({
    required this.a,
    required this.b,
    required this.c,
  });
  final int a;
  final int b;
  int c;

  void increment() {
    c++;
  }

  void decrement() {
    c--;
  }

  int getSum(int a, int b, int c) => a + b + c;
}
''',
    expectedExtension: r'''
extension CounterToFstateExtension on Counter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Counter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  } 
}
''',
    expectedExtendedState: r'''
class _$Counter implements Counter {
  _$Counter({
    required this.$setNextState,
    required int a,
    required int b,
    required int c
  }) : _state = Counter.new(a: a, b: b, c: c);

  _$Counter.from(this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get a => _state.a;

  @override
  int get b => _state.b;

  @override
  int get c => _state.c;

  @override
  set c(newVal) => _state.c = newVal;

  @override
  void increment() => _state.increment();

  @override
  void decrement() => _state.decrement();

  @override
  int getSum(int a, int b, int c) => _state.getSum(a, b, c);
}
''',
    expectedFactory: r'''
class $Counter extends FstateFactory {
  $Counter({
    required this.a,
    required this.b,
    required this.c
  }) : $stateKey = FstateKey('Counter', [Counter.new, a, b, c]);

  final int a;
  final int b;
  final int c;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [
    Param.named(#a, a),
    Param.named(#b, b),
    Param.named(#c, c)
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedInjectAnnotation: r'''
const inject$Counter$ = Finject(Counter, false);
''',
  ),
  StateGeneratorTestData(
    name: 'with actions',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';
@Fstate()
class Counter {
  Counter({
    required this.a,
    required this.b,
    required this.c,
  });
  final int a;
  final int b;
  int c;

  void increment() {
    c++;
  }

  void decrement() {
    c--;
  }

  int getSum(int a, int b, int c) => a + b + c;

  @Faction()
  void incrementAction() {
    increment();
  }

  @Faction()
  int decrementAction() {
    decrement();
    return c;
  }

  @Faction()
  Future futureAction() {
    return Future.value(0);
  }

  @Faction()
  asyncAction() async {
    return Future.value(0);
  }

  @Faction()
  Stream streamAction() {
    return Stream.value(0);
  }

  @Faction()
  asyncStreamAction() async* {
    yield 0;
  }

  @Faction(returnsNextState: true)
  Counter incrementActionReturnsNextState() {
    increment();
    return this;
  }

  @Faction(returnsNextState: true)
  Future<Counter> futureEmitter() {
    increment();
    return this;
  }
}
''',
    expectedExtension: r'''
extension CounterToFstateExtension on Counter {
  DerivedFstateBuilder toFstate() {
    return DerivedFstateBuilder(
      ($setNextState) => _$Counter.from(
        this,
        $setNextState: $setNextState,
      ),
    );
  } 
}
''',
    expectedExtendedState: r'''
class _$Counter implements Counter {
  _$Counter({
    required this.$setNextState,
    required int a,
    required int b,
    required int c
  }) : _state = Counter.new(a: a, b: b, c: c);

  _$Counter.from(this._state, {
    required this.$setNextState,
  });

  final void Function(Counter) $setNextState;
  final Counter _state;

  @override
  int get a => _state.a;

  @override
  int get b => _state.b;

  @override
  int get c => _state.c;

  @override
  set c(newVal) => _state.c = newVal;

  @override
  void increment() => _state.increment();

  @override
  void decrement() => _state.decrement();

  @override
  int getSum(int a, int b, int c) => _state.getSum(a, b, c);

  @override
  void incrementAction() {
    final result = _state.incrementAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
  }

  @override
  int decrementAction() {
    final result = _state.decrementAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  Future<dynamic> futureAction() {
    final result = _state.futureAction();
    return result.then((r) {
      $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
      return r;
    });
  }

  @override
  dynamic asyncAction() {
    final result = _state.asyncAction();
    return result.then((r) {
      $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
      return r;
    });
  }

  @override
  Stream<dynamic> streamAction() {
    final result = _state.streamAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  dynamic asyncStreamAction() {
    final result = _state.asyncStreamAction();
    $setNextState(_$Counter.from(_state, $setNextState: $setNextState));
    return result;
  }

  @override
  Counter incrementActionReturnsNextState() {
    final result = _state.incrementActionReturnsNextState();
    final nextState = _$Counter.from(result, $setNextState: $setNextState);
    $setNextState(nextState);
    return nextState;
  }

  @override
  Future<Counter> futureEmitter() {
    final result = _state.futureEmitter();
    return result.then((r) {
      final nextState = _$Counter.from(r, $setNextState: $setNextState);
      $setNextState(nextState);
      return nextState;
    });
  }
}
''',
    expectedFactory: r'''
class $Counter extends FstateFactory {
  $Counter({
    required this.a,
    required this.b,
    required this.c
  }) : $stateKey = FstateKey('Counter', [Counter.new, a, b, c]);

  final int a;
  final int b;
  final int c;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [
    Param.named(#a, a),
    Param.named(#b, b),
    Param.named(#c, c)
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedInjectAnnotation: r'''
const inject$Counter$ = Finject(Counter, false);
''',
  ),
];

class StateGeneratorTestData {
  StateGeneratorTestData({
    required this.name,
    required this.source,
    required this.expectedExtension,
    required this.expectedExtendedState,
    required this.expectedFactory,
    required this.expectedInjectAnnotation,
  });
  final String name;
  final String source;
  final String expectedExtension;
  final String expectedExtendedState;
  final String expectedFactory;
  final String expectedInjectAnnotation;
}
