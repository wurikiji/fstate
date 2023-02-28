// coverage:ignore-file
const register = _Register();
const constructor = _Constructor();
const injector = _Injector();
const notify = Notify();

class From {
  const From(this.dependsOn);
  final dynamic dependsOn;
}

class _Register {
  const _Register();
}

class _Constructor {
  const _Constructor();
}

class _Injector {
  const _Injector();
}

class Default<T> {
  const Default(this.value);
  final T value;
}

class Notify {
  const Notify();
}
