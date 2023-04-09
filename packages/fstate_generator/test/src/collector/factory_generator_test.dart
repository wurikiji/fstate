import 'package:analyzer/dart/element/element.dart';
import 'package:fstate_generator/src/generators/state_generator.dart';
import 'package:fstate_generator/src/type_checkers/annotations.dart';
import 'package:test/test.dart';

import '../../test_utils/resolver.dart';
import '../../test_utils/string_extension.dart';

void main() {
  group('Factory generator for fstate', () {
    for (final target in $factoryGeneratorTestData) {
      testWithLibraryReader(
        target.name,
        target.source,
        (library, resolver, id) {
          final fac = library
              .annotatedWith(fstateAnnotationChecker)
              .where((element) => element.element is ClassElement)
              .map((e) => e.element as ClassElement)
              .map(StateFactory.fromClassElement)
              .first;
          final actual = fac.generateFactory();
          expect(actual.format(), target.expected.format());
        },
      );
    }
  });
}

final $factoryGeneratorTestData = [
  FactoryGeneratorTestData(
    name: 'auto injection',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';

injection() {
  return 1;
}

@fstate
class Counter {
  Counter(
    @Finject(injection, true)
    int a,
  );
}
''',
    expected: r'''
class $Counter extends FstateFactory {
  $Counter(this.a) : $stateKey = FstateKey('Counter', [Counter.new, a]);

  final $injection? a;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$Counter.new;

  @override
  List<Param> get $params => [
    Param.named(#a, a ?? injection())
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
  ),
];

class FactoryGeneratorTestData {
  FactoryGeneratorTestData({
    required this.name,
    required this.source,
    required this.expected,
  });
  final String name;
  final String source;
  final String expected;
}
