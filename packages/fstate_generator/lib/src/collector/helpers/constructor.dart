import 'package:analyzer/dart/element/element.dart';

import '../data.dart';
import 'param.dart';

ConstructorMetadata parseConstructor(ExecutableElement constructor) {
  final name = constructor.name;
  final params = collectParams(constructor);

  return ConstructorMetadata(
    name: name.isEmpty ? 'new' : name,
    params: params.toList(),
  );
}
