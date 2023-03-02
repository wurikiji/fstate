import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder widgetBuilder(BuilderOptions option) {
  return SharedPartBuilder([], 'fwidget');
}
