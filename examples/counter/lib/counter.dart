import 'package:fstate/fstate.dart';

part 'counter.g.dart';

@Fstate()
class Counter {
  @Fconstructor()
  Counter();

  @Faction()
  int count = 0;
}
