import 'package:fstate/fstate.dart';

import 'counter_test.dart';

part 'backup.g.dart';

@fstate
class BBBB {
  BBBB.have(
    @inject$Counter Counter counter,
  );
}
