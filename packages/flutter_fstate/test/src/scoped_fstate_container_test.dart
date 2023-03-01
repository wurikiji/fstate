import 'package:flutter/material.dart';
import 'package:flutter_fstate/flutter_fstate.dart';
import 'package:flutter_fstate/src/scoped_fstate_container.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScopedFstateContainer', () {
    late Widget sut;
    late FstateContainer container;
    const Key key = ValueKey('sut');

    setUp(() {
      container = FstateContainer();
      sut = ScopedFstateContainer(
        container: container,
        child: Container(key: key),
      );
    });
    testWidgets('can pass FstateContainer', (tester) async {
      await tester.pumpWidget(sut);
      final finder = find.byKey(key);
      final containerElement = tester.element(finder);

      expect(() {
        final scoped = containerElement
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container = scoped.container;

        expect(container, isNotNull);
      }, isNot(throwsA(anything)));
    });
  });

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
        final scoped = containerElement
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container = scoped.container;

        expect(container, isNotNull);
      }, isNot(throwsA(anything)));
    });

    testWidgets(
      "should not change container on parent's rebuild ",
      (tester) async {
        await tester.pumpWidget(sut);

        final finder = find.byKey(key);
        final containerElement = tester.element(finder);

        final scoped = containerElement
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container = scoped.container;

        // same effect with rebuild parent
        await tester.pumpWidget(sut);

        final containerElement2 = tester.element(finder);
        final scoped2 = containerElement2
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container2 = scoped2.container;

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

        final scoped = containerElement
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container = scoped.container;

        // same effect with rebuild parent
        setState(() {});
        await tester.pumpAndSettle();

        final containerElement2 = tester.element(finder);
        final scoped2 = containerElement2
            .dependOnInheritedWidgetOfExactType<ScopedFstateContainer>()!;
        final container2 = scoped2.container;

        expect(container, equals(container2));
      },
    );
  });
}
