import 'package:dart_style/dart_style.dart';

extension Formatted on String {
  String format() {
    final formatter = DartFormatter();
    return formatter.format(this);
  }
}
