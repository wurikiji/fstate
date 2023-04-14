import 'package:fstate/fstate.dart';

import 'counter_test.dart';

part 'derived_counter_test.g.dart';

@fstate
class DerivedCounter {
  DerivedCounter(
    @inject$Counter Counter counter, {
    int a = 0,
  });
}
