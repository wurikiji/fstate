class Parameter {
  Parameter({
    required this.type,
    required this.name,
    this.defaultValue,
  });
  final String type;
  final String name;
  final String? defaultValue;

  bool get isOptional => type.endsWith('?') || defaultValue != null;

  String toNamedParam() {
    return '${isOptional ? '' : 'required'} $type $name ${defaultValue != null ? '= $defaultValue' : ''}';
  }

  String toPositionalParam() {
    return '$type $name ${defaultValue != null ? '= $defaultValue' : ''}';
  }

  String toNamedArgument() {
    return '$name: $name';
  }

  String toPositionalArgument() {
    return name;
  }
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

String joinParamNames(Iterable<Parameter> params) {
  return params.map((e) => e.name).join(', ');
}

String joinParamsToNamedParams(Iterable<Parameter> params) {
  return params.map((e) => e.toNamedParam()).join(',');
}

String joinParamsWithMetadataToArguments(
  Iterable<ParameterWithMetadata> params,
) {
  final positionals = params
      .where((e) => e.isPositional)
      .map((e) => e.parameter.toPositionalArgument())
      .join(',');
  final named = params
      .where((e) => e.isNamed)
      .map((e) => e.parameter.toNamedArgument())
      .join(',');
  return '''
  ${positionals.isNotEmpty ? '$positionals,' : ''}
  $named
''';
}

String joinParamsWithMetadata(
  Iterable<ParameterWithMetadata> params,
) {
  final positionals =
      (params.where((e) => e.isPositional && !e.parameter.isOptional).toList()
            ..sort((a, b) => a.position.compareTo(b.position)))
          .map((e) => e.parameter.toPositionalParam())
          .join(',');

  final optionals =
      (params.where((e) => e.isPositional && e.parameter.isOptional).toList()
            ..sort((a, b) => a.position.compareTo(b.position)))
          .map((e) => e.parameter.toPositionalParam())
          .join(',');

  final named = params
      .where((e) => e.isNamed)
      .map((e) => e.parameter.toNamedParam())
      .join(',');
  return '''
  ${positionals.isNotEmpty ? '$positionals,' : ''}
  ${optionals.isNotEmpty ? '[$optionals]' : ''}
  ${named.isNotEmpty ? '{$named}' : ''}
''';
}
