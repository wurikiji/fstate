import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

void main() {
  group('FstateScope', () {
    late Widget sut;
    const Key key = ValueKey('sut');

    setUp(() {
      sut = FstateScope(
        child: Container(key: key),
      );
    });
    testWidgets('can pass FstateContainer', (tester) async {
      await tester.pumpWidget(sut);

      final finder = find.byKey(key);
      final containerElement = tester.element(finder);

      expect(() {
        final container = FstateScope.containerOf(containerElement);

        expect(container, isNotNull);
      }, isNot(throwsA(anything)));
    });

    testWidgets(
      "should not change container on parent's rebuild ",
      (tester) async {
        await tester.pumpWidget(sut);

        final finder = find.byKey(key);
        final containerElement = tester.element(finder);
        final container = FstateScope.containerOf(containerElement);

        // same effect with rebuild parent
        await tester.pumpWidget(sut);

        final containerElement2 = tester.element(finder);
        final container2 = FstateScope.containerOf(containerElement2);

        expect(container, equals(container2));
      },
    );

    testWidgets(
      "should not change container on parent's rebuild with setState",
      (tester) async {
        late void Function(void Function()) setState;
        await tester.pumpWidget(StatefulBuilder(
          builder: (context, ss) {
            setState = ss;
            return FstateScope(
              child: Container(key: key),
            );
          },
        ));

        final finder = find.byKey(key);
        final containerElement = tester.element(finder);
        final container = FstateScope.containerOf(containerElement);

        // same effect with rebuild parent
        setState(() {});
        await tester.pumpAndSettle();

        final containerElement2 = tester.element(finder);
        final container2 = FstateScope.containerOf(containerElement2);

        expect(container, equals(container2));
      },
    );

    testWidgets("should throw when it's not used", (tester) async {
      await tester.pumpWidget(Container());
      final container = find.byType(Container);
      final element = tester.element(container);
      expect(() {
        FstateScope.containerOf(element);
        fail('should throw before this line');
      }, throwsA(
        predicate((
          FstateScopeException e,
        ) {
          return e
              .toString()
              .contains('You should wrap your widget with FstateScope');
        }),
      ));
    });
  });
}
