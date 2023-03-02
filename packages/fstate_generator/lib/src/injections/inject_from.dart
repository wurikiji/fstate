import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../utils/element.dart';
import '../wrapper/basic_constructor.dart';

abstract class InjectionFrom {
  InjectionFrom._(this.constructor, this.element);

  factory InjectionFrom(BaseConstructor constructor, ParameterElement element) {
    if (isElementFromFunction(element)) {
      return InjectFromFunction._(constructor, element);
    }
    if (!isElementFromFstateKey(element) && !isElementNull(element)) {
      throw InvalidGenerationSourceError(
        'Invalid value for "from" parameter in @Inject annotation.'
        'Must be a generated key or a function.',
        element: element,
      );
    }
    return InjectFromFstateKey._(constructor, element);
  }

  final ParameterElement element;
  final BaseConstructor constructor;

  String get name => element.displayName;
  String get type => element.type.getDisplayString(withNullability: false);
  bool get isOptional => element.isOptional;
  int get index => constructor.parameters.indexOf(element);

  String get injectionCode;
}

class InjectFromFunction extends InjectionFrom {
  InjectFromFunction._(
    BaseConstructor constructor,
    ParameterElement element,
  ) : super._(constructor, element);

  DartObject get annotation => getInjectionAnnotation(element);

  @override
  String get injectionCode => '';
}

class InjectFromFstateKey extends InjectionFrom {
  InjectFromFstateKey._(
    BaseConstructor constructor,
    ParameterElement element,
  ) : super._(constructor, element);

  String get injectedKey =>
      getInjectionFromField(element).variable!.displayName;

  String get keyName => isElementNull(element)
      ? '\$${sentenceCaseToCamelCase(type)}'
      : injectedKey;

  @override
  String get injectionCode => 'container.get($keyName)';
}
