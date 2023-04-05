// coverage:ignore-file

import 'package:meta/meta_meta.dart';

/// Annotate class to register it.

/// Annotate class to extend it to reactive state.
@Target({TargetKind.classType})
class Fstate {
  const Fstate();
}

/// Annotate function to use it as a selector.
@Target({TargetKind.function})
class Fselector {
  const Fselector();
}

/// Annotate widget to implement it.
@Target({TargetKind.classType})
class Fwidget {
  const Fwidget();
}

typedef Alternator = Stream Function(Stream source);

/// Annotate parameters to be auto-injected.
///
/// [derivedFrom]
/// [alternator] should returns a same type of stream with source.
@Target({TargetKind.parameter})
class Finject {
  const Finject({this.derivedFrom, this.alternator});
  final Function? derivedFrom;
  final Alternator? alternator;
}

/// Annotate methods as a state changer.
@Target({TargetKind.method, TargetKind.setter, TargetKind.field})
class Faction {
  const Faction({this.returnsNextState = false});

  /// If true, the method should return the next state,
  /// which is same type of annotated class.
  final bool returnsNextState;
}

/// Annotate a constructor as a base constructor.
class Fconstructor {
  const Fconstructor();
}
