import 'package:fstate/fstate.dart';

final fc = FContainer();

class _WiredTestTarget implements TestTarget {
  @override
  String get name {
    final WantToInject dep1 = fc.get();
    return getName(dep1);
  }

  @override
  WantToInject get wantToInject {
    return fc.get();
  }

  _WiredTestTarget();

  TestTarget? _instance;

  TestTarget get _testTarget => _instance ??= TestTarget(name, wantToInject);

  @override
  hello() {
    return _testTarget.hello();
  }
}

@register
class WantToInject {
  @Default('hello')
  final String name;

  WantToInject(this.name);
}

String getName(WantToInject a) {
  return a.name;
}

class TestTarget {
  const TestTarget(this.name, this.wantToInject);

  @injector
  factory TestTarget.wired() = _WiredTestTarget;

  @From(WantToInject)
  final WantToInject wantToInject;

  @From(getName)
  final String name;

  hello() {
    print(name);
  }
}

main() {
  final tt = _WiredTestTarget();
  tt.hello();
}
