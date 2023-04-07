import 'package:build/build.dart';
import 'package:fstate_generator/src/generators/selector_generator.dart';
import 'package:fstate_generator/src/generators/state_generator.dart';
import 'package:fstate_generator/src/generators/widget_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder coreBuilder(BuilderOptions option) {
  return SharedPartBuilder(
    [
      StateGenerator(),
      WidgetGenerator(),
      SelectorGenerator(),
    ],
    'fstate',
  );
}
