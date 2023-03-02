// coverage:ignore-file

/// Annotate class to register it.
const fstate = Fstate();
const constructor = Constructor();
const notify = Notify();

class Fstate {
  const Fstate();
}

/// Annotate widget to implement it.
class Fwidget {
  const Fwidget();
}

/// Annotation to inject dependency.
class Inject {
  const Inject({this.from});
  final dynamic from;
}

/// Annotate method as a state changer.
class Notify {
  const Notify();
}

/// Annotation to mark the constructor as base constructor.
class Constructor {
  const Constructor();
}
