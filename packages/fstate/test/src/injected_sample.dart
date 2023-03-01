import 'package:fstate/fstate.dart';

final fc = FstateContainer();

class _WiredTestTarget implements TestTarget {
  _WiredTestTarget(this.i);
  late final FstateContainer container;

  @override
  String get name {
    final WantToInject dep1 = fc.get('key');
    return getName(dep1);
  }

  @override
  WantToInject get wantToInject {
    return fc.get('key');
  }

  TestTarget? _instance;

  TestTarget get _testTarget => _instance ??= TestTarget(name, wantToInject, i);

  @override
  final int i;

  @override
  hello() {
    return _testTarget.hello();
  }
}

@fstate
class WantToInject {
  @Inject('hello')
  final String name;

  WantToInject(this.name);
}

String getName(WantToInject a) {
  return a.name;
}

extension AutoInjectedTestTarget on TestTarget {
  static int a = 10;
}

@fstate
class TestTarget {
  @base
  const TestTarget(this.name, this.wantToInject, this.i);

  @generated
  factory TestTarget.wired(int i) = _WiredTestTarget;

  @Inject(WantToInject)
  final WantToInject wantToInject;

  @Inject(getName)
  final String name;

  final int i;

  hello() {
    print(name);
  }
}

main() {
  final tt = _WiredTestTarget(10);
  tt.container = FstateContainer();
  tt.hello();
}
