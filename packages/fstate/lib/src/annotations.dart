// coverage:ignore-file
const fstate = FState();
const generated = FStateConstructor();
const base = BaseConstructor();
const notify = Notify();

/// Annotation to inject dependency.
class Inject {
  const Inject(this.from);
  final dynamic from;
}

/// Annotate method as a state changer.
class Notify {
  const Notify();
}

/// Annotate class to register it.
class FState {
  const FState();
}

/// Annotation to mark the constructor as base constructor.
class BaseConstructor {
  const BaseConstructor();
}

/// Annotation for auto generated constructor.
class FStateConstructor {
  const FStateConstructor();
}
