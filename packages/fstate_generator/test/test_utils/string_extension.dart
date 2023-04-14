import 'package:dart_style/dart_style.dart';

extension WithFstateAnnotationPackage on String {
  String get withFstateAnnotationPackage => '''
import 'package:fstate_annotation/fstate_annotation.dart';

$this
''';
}

extension Formatted on String {
  String format() {
    final formatter = DartFormatter();
    return formatter.format(this);
  }
}
