import 'package:fstate/fstate.dart';

part 'counter.g.dart';

@fstate
class Counter {
  Counter(this.count);
  int count;

  @faction
  void increment() {
    count++;
  }

  @faction
  void decrement() {
    count--;
  }
}
