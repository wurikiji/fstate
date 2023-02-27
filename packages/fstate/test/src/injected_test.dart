class From {
  const From(this.dependsOn);
  final dynamic dependsOn;
}

class Register {
  const Register();
}

class Constructor {
  const Constructor();
}

class Default<T> {
  const Default(this.value);
  final T value;
}

class Inject {
  const Inject();
}

class FContainer {
  T find<T>() {
    final stored = _store[T];
    if (stored == null) {
      throw 'You did not register $T';
    }
    return stored;
  }

  final Map<Type, dynamic> _store = {
    WantToInject: WantToInject('hello'),
  };
}

final fc = FContainer();

class _WiredTestTarget implements TestTarget {
  @override
  String get name {
    final WantToInject dep1 = fc.find();
    return getName(dep1);
  }

  @override
  WantToInject get wantToInject {
    return fc.find();
  }

  _WiredTestTarget();

  TestTarget? _instance;

  TestTarget get _testTarget => _instance ??= TestTarget(name, wantToInject);

  @override
  hello() {
    return _testTarget.hello();
  }
}

@Register()
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

  @Inject()
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
