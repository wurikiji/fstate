import 'inject_from.dart';

class InjectionPlace {
  const InjectionPlace._(this.parameter);
  factory InjectionPlace(InjectionFrom parameter) {
    if (parameter.element.isPositional) {
      return PositionalInjection._(parameter);
    }
    return NamedInjection._(parameter);
  }
  final InjectionFrom parameter;

  String get name => parameter.element.name;
}

class PositionalInjection extends InjectionPlace {
  const PositionalInjection._(InjectionFrom parameter) : super._(parameter);
  int get index => parameter.index;

  @override
  String toString() {
    final value = '${name}Value';
    return '''
final $value = ${parameter.injectionCode};
final $name = PositionalParam(index: $index, value: $value);
''';
  }
}

class NamedInjection extends InjectionPlace {
  const NamedInjection._(InjectionFrom parameter) : super._(parameter);

  @override
  String toString() {
    final value = '${name}Value';
    return '''
final $value = ${parameter.injectionCode};
final $name = MapEntry(#$name, $value);
''';
  }
}
