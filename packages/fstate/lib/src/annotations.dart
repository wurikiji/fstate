// coverage:ignore-file
const baseConstructor = BaseConstructor();

/// Annotate class to register it.
class Fstate {
  const Fstate();
}

/// Annotate widget to implement it.

/// Annotation to inject dependency.
class Inject {
  const Inject({this.from});
  final Function? from;
}

/// Annotate method as a state changer.
class Notify {
  const Notify();
}

/// Annotation to mark the constructor as base constructor.
class BaseConstructor {
  const BaseConstructor();
}
