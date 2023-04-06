import 'dart:async';

import 'package:build/build.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder coreBuilder(BuilderOptions option) {
  return SharedPartBuilder(
    [
      StateGenerator(),
      WidgetGenerator(),
    ],
    'fstate',
  );
}

class StateGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fstates = library.annotatedWith(fstateAnnotationChecker);
    return null;
  }
}

class SelectorGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fselectors = library.annotatedWith(fwidgetAnnotationChecker);
    return super.generate(library, buildStep);
  }
}

class WidgetGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final fwidgets = library.annotatedWith(fwidgetAnnotationChecker);
    return super.generate(library, buildStep);
  }
}
