final $selectorTestData = [
  SelectorTestData(
    name: 'no param',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';

@Fstate()
int add2() => 1;
''',
    expectedExtendedSelector: r'''
int _$add2({$setNextState}) {
  final result = add2();
  try {
      return (result).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}
''',
    expectedFactory: r'''
class $add2 extends FstateFactory {
  $add2() : $stateKey = FstateKey('int', [add2]);

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$add2;

  @override
  List<Param> get $params => [];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedAnnotation: r'''
const inject$add2 = Finject(add2, true);
''',
  ),
  SelectorTestData(
    name: 'change all params to named params',
    source: r'''
import 'package:fstate_annotation/fstate_annotation.dart';

@Fstate()
int add(int a, int b, {required int c, int d = 0}) => 1;
''',
    expectedExtendedSelector: r'''
int _$add({
  $setNextState, 
  required int a,
  required int b,
  required int c,
  int d = 0
}) {
  final result = add(a, b, c: c, d: d);
  try {
      return (result).toFstate().$buildState($setNextState);
  } catch (_) {
    return result;
  }
}
''',
    expectedFactory: r'''
class $add extends FstateFactory {
  $add(this.a, this.b, {required this.c, this.d = 0}) : $stateKey = FstateKey('int', [add, a, b, c, d]);

  final int a;
  final int b;
  final int c;
  final int d;

  @override
  final FstateKey $stateKey;

  @override
  Function get $stateBuilder => _$add;

  @override
  List<Param> get $params => [
    Param.named(#a, a),
    Param.named(#b, b),
    Param.named(#c, c),
    Param.named(#d, d)
  ];

  @override
  Map<dynamic, FTransformer> get $transformers => {};
}
''',
    expectedAnnotation: r'''
const inject$add$ = Finject(add, false);
''',
  ),
];

class SelectorTestData {
  const SelectorTestData({
    required this.name,
    required this.source,
    required this.expectedExtendedSelector,
    required this.expectedFactory,
    required this.expectedAnnotation,
  });
  final String name;
  final String source;
  final String expectedExtendedSelector;
  final String expectedFactory;
  final String expectedAnnotation;
}
