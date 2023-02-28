import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder coreBuilder(BuilderOptions option) {
  return SharedPartBuilder([], 'fstate');
}
