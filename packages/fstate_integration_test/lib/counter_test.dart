import 'package:fstate/fstate.dart';

part 'counter_test.g.dart';

@fstate
class Counter {
  Counter({
    this.a = 0,
    this.b = 0,
    this.c = 0,
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
    return 0;
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
  Future<Counter> futureEmitter() async {
    increment();
    return this;
  }
}

void main() {}
