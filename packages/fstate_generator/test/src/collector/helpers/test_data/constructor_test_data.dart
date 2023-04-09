import 'package:fstate_generator/src/collector/data.dart';

import '../../../../test_utils/string_extension.dart';

final $classData = [
  TestMetaData(
    test: 'no conscturctor',
    source: r'''
      @Fstate()
      class Counter {
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [],
    ),
  ),
  TestMetaData(
    test: 'Default constructor',
    source: r'''
      @Fstate()
      class Counter {
        Counter();
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [],
    ),
  ),
  TestMetaData(
    test: 'Named conscturctor',
    source: r'''
      @Fstate()
      class Counter {
        Counter.value();
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'value',
      params: [],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with required positional params',
    source: r'''
      @Fstate()
      class Counter {
        Counter(int value, int value2);
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [
        ParameterMetadata(
          type: 'int',
          name: 'value',
          position: 0,
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value2',
          position: 1,
          needManualInject: true,
        ),
      ],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with required named params',
    source: r'''
      @Fstate()
      class Counter {
        Counter({required int value, required int value2, required int value3});
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [
        ParameterMetadata(
          type: 'int',
          name: 'value',
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value2',
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value3',
          needManualInject: true,
        ),
      ],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with optional positional params',
    source: r'''
      @Fstate()
      class Counter {
        Counter(int? value, [int value2 = 0]);
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [
        ParameterMetadata(
          type: 'int?',
          name: 'value',
          position: 0,
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value2',
          defaultValue: '0',
          position: 1,
          needManualInject: false,
        ),
      ],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with optional named params',
    source: r'''
      @Fstate()
      class Counter {
        Counter({int? value, int value2 = 0});
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [
        ParameterMetadata(
          type: 'int?',
          name: 'value',
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value2',
          defaultValue: '0',
          needManualInject: false,
        ),
      ],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with all',
    source: r'''
      @Fstate()
      class Counter {
        Counter.value(int value, int? value2, {required int value3, int? value4 = 0});
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'value',
      params: [
        ParameterMetadata(
          type: 'int',
          name: 'value',
          needManualInject: true,
          position: 0,
        ),
        ParameterMetadata(
          type: 'int?',
          name: 'value2',
          position: 1,
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value3',
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int?',
          name: 'value4',
          defaultValue: '0',
          needManualInject: false,
        ),
      ],
    ),
  ),
  TestMetaData(
    test: 'conscturctor with optional named params',
    source: r'''

      int testSelector() => 0;

      Stream alternator(Stream s) => s;

      @Fstate()
      class Counter {
        Counter(int? value, {
          @Ftransform(alternator)
          @inject$testSelector required int value2});
      }
    '''
        .withFstateAnnotationPackage,
    expected: ConstructorMetadata(
      name: 'new',
      params: [
        ParameterMetadata(
          type: 'int?',
          name: 'value',
          position: 0,
          needManualInject: true,
        ),
        ParameterMetadata(
          type: 'int',
          name: 'value2',
          injectedFrom: 'testSelector',
          transformer: 'alternator',
          needManualInject: false,
        ),
      ],
    ),
  ),
];

class TestMetaData {
  final String test;
  final String source;
  final ConstructorMetadata expected;

  TestMetaData({
    required this.test,
    required this.source,
    required this.expected,
  });
}
