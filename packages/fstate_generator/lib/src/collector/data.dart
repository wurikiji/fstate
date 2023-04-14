class FstateMetadata {
  FstateMetadata({
    required this.name,
    required this.constructors,
    this.normalMethods = const [],
    this.actionMethods = const [],
    this.fields = const [],
  });

  final String name;
  final List<ConstructorMetadata> constructors;
  final List<MethodMetadata> normalMethods;
  final List<MethodMetadata> actionMethods;
  final List<FieldMetadata> fields;

  Map<String, dynamic> toJson() => _$FstateMetadataToJson(this);
  factory FstateMetadata.fromJson(Map<String, dynamic> json) =>
      _$FstateMetadataFromJson(json);
}

class ConstructorMetadata {
  ConstructorMetadata({
    required this.name,
    this.params = const [],
  });
  final String name;
  final List<ParameterMetadata> params;
  Map<String, dynamic> toJson() => _$ConstructorMetadataToJson(this);
  factory ConstructorMetadata.fromJson(Map<String, dynamic> json) =>
      _$ConstructorMetadataFromJson(json);
}

class ParameterMetadata {
  ParameterMetadata({
    required this.type,
    required this.name,
    required this.needManualInject,
    this.defaultValue,
    this.injectedFrom,
    this.position = -1,
    this.transformer,
  });

  final String type;
  final String name;
  final int position;
  final String? defaultValue;
  final String? injectedFrom;
  final String? transformer;
  final bool needManualInject;

  bool get isPositional => position != -1;
  bool get isNamed => !isPositional;
  bool get isRequired => !type.endsWith('?') && defaultValue == null;

  Map<String, dynamic> toJson() => _$ParameterMetadataToJson(this);
  factory ParameterMetadata.fromJson(Map<String, dynamic> json) =>
      _$ParameterMetadataFromJson(json);

  String toNamedParam(bool isField) {
    final required = isRequired ? 'required' : '';
    final type = isField ? '' : this.type;
    final name = isField ? 'this.${this.name}' : this.name;
    final defaultValue =
        this.defaultValue != null ? '= ${this.defaultValue}' : '';

    return '$required $type $name $defaultValue';
  }

  String toPositionalParam(bool isField, bool assignDefaultValue) {
    final type = isField ? '' : this.type;
    final name = isField ? 'this.${this.name}' : this.name;
    final defaultValue = (assignDefaultValue && this.defaultValue != null)
        ? '= ${this.defaultValue}'
        : '';
    return '$type $name $defaultValue';
  }

  String toNamedArg() {
    return '$name: $name';
  }

  String toPositionalArg() {
    return name;
  }

  String toFinalField() {
    return 'final $type $name;';
  }
}

class MethodMetadata {
  MethodMetadata({
    required this.name,
    required this.returnType,
    required this.isAsynchronous,
    required this.isStream,
    this.params = const [],
    this.isEmitter = false,
  });
  final String name;
  final String returnType;
  final List<ParameterMetadata> params;
  final bool isEmitter;
  final bool isAsynchronous;
  final bool isStream;

  Map<String, dynamic> toJson() => _$MethodMetadataToJson(this);
  factory MethodMetadata.fromJson(Map<String, dynamic> json) =>
      _$MethodMetadataFromJson(json);
}

class FieldMetadata {
  FieldMetadata({
    required this.name,
    required this.type,
    required this.isGetter,
    required this.isSetter,
  });

  final String name;
  final String type;
  final bool isGetter;
  final bool isSetter;

  Map<String, dynamic> toJson() => _$FieldMetadataToJson(this);
  factory FieldMetadata.fromJson(Map<String, dynamic> json) =>
      _$FieldMetadataFromJson(json);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FstateMetadata _$FstateMetadataFromJson(Map<String, dynamic> json) =>
    FstateMetadata(
      name: json['name'] as String,
      constructors: (json['constructors'] as List<dynamic>)
          .map((e) => ConstructorMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      normalMethods: (json['normalMethods'] as List<dynamic>?)
              ?.map((e) => MethodMetadata.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      actionMethods: (json['actionMethods'] as List<dynamic>?)
              ?.map((e) => MethodMetadata.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => FieldMetadata.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FstateMetadataToJson(FstateMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'constructors': instance.constructors,
      'normalMethods': instance.normalMethods,
      'actionMethods': instance.actionMethods,
      'fields': instance.fields,
    };

ConstructorMetadata _$ConstructorMetadataFromJson(Map<String, dynamic> json) =>
    ConstructorMetadata(
      name: json['name'] as String,
      params: (json['params'] as List<dynamic>?)
              ?.map(
                (e) => ParameterMetadata.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConstructorMetadataToJson(
  ConstructorMetadata instance,
) =>
    <String, dynamic>{
      'name': instance.name,
      'params': instance.params,
    };

ParameterMetadata _$ParameterMetadataFromJson(Map<String, dynamic> json) =>
    ParameterMetadata(
      type: json['type'] as String,
      name: json['name'] as String,
      needManualInject: json['needManualInject'] as bool,
      defaultValue: json['defaultValue'] as String?,
      injectedFrom: json['injectedFrom'] as String?,
      position: json['position'] as int? ?? -1,
      transformer: json['transformer'] as String?,
    );

Map<String, dynamic> _$ParameterMetadataToJson(ParameterMetadata instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'position': instance.position,
      'defaultValue': instance.defaultValue,
      'injectedFrom': instance.injectedFrom,
      'transformer': instance.transformer,
      'needManualInject': instance.needManualInject,
    };

MethodMetadata _$MethodMetadataFromJson(Map<String, dynamic> json) =>
    MethodMetadata(
      name: json['name'] as String,
      returnType: json['returnType'] as String,
      isAsynchronous: json['isAsynchronous'] as bool,
      isStream: json['isStream'] as bool,
      params: (json['params'] as List<dynamic>?)
              ?.map(
                (e) => ParameterMetadata.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      isEmitter: json['isEmitter'] as bool? ?? false,
    );

Map<String, dynamic> _$MethodMetadataToJson(MethodMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'returnType': instance.returnType,
      'params': instance.params,
      'isEmitter': instance.isEmitter,
      'isAsynchronous': instance.isAsynchronous,
      'isStream': instance.isStream,
    };

FieldMetadata _$FieldMetadataFromJson(Map<String, dynamic> json) =>
    FieldMetadata(
      name: json['name'] as String,
      type: json['type'] as String,
      isGetter: json['isGetter'] as bool,
      isSetter: json['isSetter'] as bool,
    );

Map<String, dynamic> _$FieldMetadataToJson(FieldMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'isGetter': instance.isGetter,
      'isSetter': instance.isSetter,
    };
