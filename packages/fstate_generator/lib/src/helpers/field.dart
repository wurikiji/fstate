class FstateField {
  FstateField({
    required this.type,
    required this.name,
    required this.isFinal,
    required this.isGetter,
    required this.isSetter,
    this.dfeaultValue,
  });

  final String type;
  final String name;
  final bool isFinal;
  final bool isGetter;
  final bool isSetter;
  final String? dfeaultValue;

  bool get isGetterSetter => isGetter && isSetter;

  String proxyFieldTo(String proxy) {
    return '''
${isGetter ? _proxyGetterTo(proxy) : ''}
${isSetter ? _proxySetterTo(proxy) : ''}
''';
  }

  String _proxySetterTo(String proxy) {
    return '''
@override
set $name($type value) => $proxy.$name = value;
''';
  }

  String _proxyGetterTo(String proxy) {
    return '''
@override
$type get $name => $proxy.$name;
''';
  }
}
