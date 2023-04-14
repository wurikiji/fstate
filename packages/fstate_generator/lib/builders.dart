import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/selector_generator.dart';
import 'src/generators/state_generator.dart';
import 'src/generators/widget_generator.dart';

Builder stateGenerator(BuilderOptions option) {
  return SharedPartBuilder(
    [
      StateGenerator(),
      SelectorGenerator(),
      WidgetGenerator(),
    ],
    'fstate',
    allowSyntaxErrors: true,
  );
}
