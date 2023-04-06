class Parameter {
  Parameter({
    required this.type,
    required this.name,
    this.defaultValue,
  });
  final String type;
  final String name;
  final String? defaultValue;
}

class ParameterWithMetadata {
  ParameterWithMetadata._({
    required this.parameter,
    required this.isRequired,
    required this.isPositional,
    required this.position,
  }) : assert(!isPositional || position >= 0,
            'positional parameter\'s position should be >= 0');

  ParameterWithMetadata.positional({
    required Parameter parameter,
    required int position,
  }) : this._(
          parameter: parameter,
          isPositional: true,
          isRequired: true,
          position: position,
        );

  ParameterWithMetadata.named({
    required Parameter parameter,
    required bool isRequired,
  }) : this._(
          parameter: parameter,
          isRequired: isRequired,
          isPositional: false,
          position: -1,
        );

  final Parameter parameter;
  final bool isRequired;
  final bool isPositional;
  final int position;

  bool get isOptional => !isRequired;
  bool get isNamed => !isPositional;
}
