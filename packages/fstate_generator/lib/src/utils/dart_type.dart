import 'package:analyzer/dart/element/type.dart';

extension TypeWithNullability on DartType {
  String get typeWithNullability =>
      getDisplayString(withNullability: true).replaceAll('*', '');
}
