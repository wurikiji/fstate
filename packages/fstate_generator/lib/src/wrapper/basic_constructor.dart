import 'package:analyzer/dart/element/element.dart';

class BaseConstructor {
  const BaseConstructor(this.constructor);
  final ConstructorElement constructor;

  List<ParameterElement> get parameters => constructor.parameters;
  Iterable<ParameterElement> get positionalParameters =>
      parameters.where((element) => element.isPositional);
  Iterable<ParameterElement> get namedParameters =>
      parameters.where((element) => element.isNamed);

  @override
  String toString() => constructor.displayName;
}
