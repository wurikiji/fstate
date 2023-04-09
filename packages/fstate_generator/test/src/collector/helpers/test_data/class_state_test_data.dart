import 'package:fstate_generator/src/collector/data.dart';

import '../../../../test_utils/string_extension.dart';

final $fstateTestData = [
  ClassStateTestData(
    name: 'nothing',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {}
'''
        .withFstateAnnotationPackage
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'only normal methods',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  void increment() {}
  int decrement() {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      normalMethods: [
        MethodMetadata(
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
          isStream: false,
        ),
        MethodMetadata(
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
          isStream: false,
        ),
      ],
    ),
  ),

  /// All permutations of test cases
  ClassStateTestData(
    name: 'only action methods',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment() {}
  @Faction()
  int decrement() {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'action methods and normal methods',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment() {}
  @Faction()
  int decrement() {}
  void normal() {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
        ),
      ],
      normalMethods: [
        MethodMetadata(
          isStream: false,
          name: 'normal',
          returnType: 'void',
          isAsynchronous: false,
        ),
      ],
    ),
  ),

  /// All permutations of methods with all permutations of params
  ClassStateTestData(
    name: 'action methods with positional params',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment(int value) {}
  @Faction()
  int decrement(int value) {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
          params: [
            ParameterMetadata(
              type: 'int',
              name: 'value',
              position: 0,
              needManualInject: true,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
          params: [
            ParameterMetadata(
              type: 'int',
              name: 'value',
              position: 0,
              needManualInject: true,
            ),
          ],
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'action methods with named params',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment({int value = 0}) {}
  @Faction()
  int decrement({int value = 0}) {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
          params: [
            ParameterMetadata(
              type: 'int',
              name: 'value',
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          isAsynchronous: false,
          returnType: 'int',
          params: [
            ParameterMetadata(
              type: 'int',
              name: 'value',
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'action methods with positional and named params',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment(int value, {int value2 = 0}) {}
  @Faction()
  int decrement(int value, {int value2 = 0}) {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          isAsynchronous: false,
          returnType: 'void',
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          isAsynchronous: false,
          returnType: 'int',
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'normal methods with named and positional params',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  void increment(int value, {int value2 = 0}) {}
  int decrement(int value, {int value2 = 0}) {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      normalMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'normal and action methods with named and positional params',
    className: 'Counter',
    source: r'''
@Fstate()
class Counter {
  @Faction()
  void increment(int value, {int value2 = 0}) {}
  @Faction()
  int decrement(int value, {int value2 = 0}) {}
  void normal(int value, {int value2 = 0}) {}
  int normal2(int value, {int value2 = 0}) {}
}
'''
        .withFstateAnnotationPackage,
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      actionMethods: [
        MethodMetadata(
          isStream: false,
          name: 'increment',
          returnType: 'void',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'decrement',
          returnType: 'int',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
      ],
      normalMethods: [
        MethodMetadata(
          isStream: false,
          name: 'normal',
          returnType: 'void',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
        MethodMetadata(
          isStream: false,
          name: 'normal2',
          returnType: 'int',
          isAsynchronous: false,
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
              defaultValue: '0',
              needManualInject: false,
            ),
          ],
        ),
      ],
    ),
  ),
  ClassStateTestData(
    name: 'all kind of fields',
    source: r'''
@Fstate()
class Counter {
  final int value;
  final dynamic value2;
  final String value3;
  double? value4;
  final void Function() value5;
  int get value6 => 0;
  set value7(int value) {}
}
''',
    className: 'Counter',
    expected: FstateMetadata(
      name: 'Counter',
      constructors: [
        ConstructorMetadata(name: 'new'),
      ],
      fields: [
        FieldMetadata(
          name: 'value',
          type: 'int',
          isGetter: true,
          isSetter: false,
        ),
        FieldMetadata(
          name: 'value2',
          type: 'dynamic',
          isGetter: true,
          isSetter: false,
        ),
        FieldMetadata(
          name: 'value3',
          type: 'String',
          isGetter: true,
          isSetter: false,
        ),
        FieldMetadata(
          name: 'value4',
          type: 'double?',
          isGetter: true,
          isSetter: true,
        ),
        FieldMetadata(
          name: 'value5',
          type: 'void Function()',
          isGetter: true,
          isSetter: false,
        ),
        FieldMetadata(
          name: 'value6',
          type: 'int',
          isGetter: true,
          isSetter: false,
        ),
        FieldMetadata(
          name: 'value7',
          type: 'int',
          isSetter: true,
          isGetter: false,
        ),
      ],
    ),
  ),
];

class ClassStateTestData {
  ClassStateTestData({
    required this.name,
    required this.source,
    required this.className,
    required this.expected,
  });
  final String name;
  final String source;
  final String className;
  final FstateMetadata expected;
}
