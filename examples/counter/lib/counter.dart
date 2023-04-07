import 'package:fstate/fstate.dart';

part 'counter.g.dart';

@Fstate()
class Counter {
  @Fconstructor()
  Counter();

  @Faction()
  int count = 0;

  @Faction()
  Future increment() async {
    count++;
  }

  @Faction(returnsNextState: true)
  Counter decrement() {
    return Counter()..count = count - 1;
  }

  @Faction(returnsNextState: true)
  Future<Counter> randomize() async {
    await Future.delayed(const Duration(seconds: 1));
    return Counter()..count = count + 1;
  }
}
