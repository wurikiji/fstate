import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../utils/element.dart';
import '../wrapper/base_constructor.dart';

abstract class InjectionFrom {
  InjectionFrom._(this.constructor, this.element);

  factory InjectionFrom(BaseConstructor constructor, ParameterElement element) {
    if (isInjectionFromFunction(element)) {
      return InjectFromFunction._(constructor, element);
    }
    if (!isElementFromFstateKey(element) && !isInjectionFromNull(element)) {
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
  DartObject get annotation => getInjectionAnnotation(element)!;

  String get injectionCode;
}

class InjectFromFunction extends InjectionFrom {
  InjectFromFunction._(
    BaseConstructor constructor,
    ParameterElement element,
  ) : super._(constructor, element);

  @override
  String get injectionCode =>
      getInjectionFromField(element)!.toFunctionValue()!.displayName;
}

class InjectFromFstateKey extends InjectionFrom {
  InjectFromFstateKey._(
    BaseConstructor constructor,
    ParameterElement element,
  ) : super._(constructor, element);

  String get _injectedKey {
    return getInjectionFromField(element)!.variable!.displayName;
  }

  String get keyName => isInjectionFromNull(element)
      ? '\$${sentenceCaseToCamelCase(type)}'
      : _injectedKey;

  @override
  String get injectionCode => keyName;
}
