// coverage:ignore-file

import 'package:meta/meta_meta.dart';

const fstate = Fstate();
const fwidget = Fwidget();
const fconstructor = Fconstructor();
const faction = Faction();

/// Annotate class to extend it to reactive state.
@Target({TargetKind.classType, TargetKind.function})
class Fstate {
  const Fstate();
}

class Fconstructor {
  const Fconstructor();
}

typedef FTransformer<T> = Stream<T> Function(Stream<T> source);

/// Annotate parameters to be auto-injected.
/// ***Users should not use this annotation directly.***
/// Instead, generator will use this annotation internally.
@Target({TargetKind.parameter})
class Finject {
  const Finject(this.from, this.autoInjectable);

  /// If a constructor parameter is derived from a selector,
  /// annotate the selector with [Fselector] and
  /// give the selector's name to [from].
  final dynamic from;

  /// Internal use only for generator.
  /// If true, the parameter will be auto-injected.
  /// If false, the parameter needs to be injected manually.
  final bool autoInjectable;
}

/// Annotate parameter to transform streams.
class Ftransform {
  const Ftransform(this.transformer);

  /// If you want to alter timing of the stream,
  /// give an [FTransformer] to [alternator].
  final FTransformer? transformer;
}

/// Annotate methods as a state changer.
@Target({TargetKind.method})
class Faction {
  const Faction({this.returnsNextState = false});

  /// If true, the method should return the next state,
  /// which is same type of annotated class.
  final bool returnsNextState;
}

/// Annotate widgets to extend them to reactive widgets.
@Target({TargetKind.classType})
class Fwidget {
  const Fwidget();
}
