class Parameter {
  Parameter({
    required this.type,
    required this.name,
    required this.autoInject,
    this.defaultValue,
  });
  final String type;
  final String name;
  final String? defaultValue;
  final bool autoInject;

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

class ParameterWithMetadata extends Parameter {
  ParameterWithMetadata._({
    required super.name,
    required super.type,
    required this.isPositional,
    required this.position,
    required super.autoInject,
    super.defaultValue,
  }) : assert(!isPositional || position >= 0,
            'positional parameter\'s position should be >= 0');

  ParameterWithMetadata.positional({
    required String name,
    required String type,
    required int position,
    required bool autoInject,
    String? defaultValue,
  }) : this._(
          name: name,
          type: type,
          defaultValue: defaultValue,
          isPositional: true,
          position: position,
          autoInject: autoInject,
        );

  ParameterWithMetadata.named({
    required String name,
    required String type,
    required bool autoInject,
    String? defaultValue,
  }) : this._(
          name: name,
          type: type,
          defaultValue: defaultValue,
          isPositional: false,
          position: -1,
          autoInject: autoInject,
        );

  final bool isPositional;
  final int position;

  bool get isRequired => !isOptional;
  bool get isNamed => !isPositional;
}

String joinParamNames(Iterable<Parameter> params) {
  return params.map((e) => e.name).join(', ');
}

String joinParamsToNamedParams(Iterable<Parameter> params) {
  return params.map((e) => e.toNamedParam()).join(',');
}

String joinParamsToNamedArguments(Iterable<Parameter> params) {
  return params.map((e) => e.toNamedArgument()).join(',');
}

String joinParamsWithMetadataToArguments(
  Iterable<ParameterWithMetadata> params,
) {
  final positionals = params
      .where((e) => e.isPositional)
      .map((e) => e.toPositionalArgument())
      .join(',');
  final named =
      params.where((e) => e.isNamed).map((e) => e.toNamedArgument()).join(',');
  return '''
  ${positionals.isNotEmpty ? '$positionals,' : ''}
  $named
''';
}

String joinParamsWithMetadata(
  Iterable<ParameterWithMetadata> params,
) {
  final positionals =
      (params.where((e) => e.isPositional && !e.isOptional).toList()
            ..sort((a, b) => a.position.compareTo(b.position)))
          .map((e) => e.toPositionalParam())
          .join(',');

  final optionals =
      (params.where((e) => e.isPositional && e.isOptional).toList()
            ..sort((a, b) => a.position.compareTo(b.position)))
          .map((e) => e.toPositionalParam())
          .join(',');

  final named =
      params.where((e) => e.isNamed).map((e) => e.toNamedParam()).join(',');
  return '''
  ${positionals.isNotEmpty ? '$positionals,' : ''}
  ${optionals.isNotEmpty ? '[$optionals]' : ''}
  ${named.isNotEmpty ? '{$named}' : ''}
''';
}
