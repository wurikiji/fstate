import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

part 'auto_dispose_test.g.dart';

void main() {
  group('Auto dispose', () {
    test('only on state', () async {
      final container = FstateStreamContainer();
      final root = $Root();
      expect(container.contains(root.$stateKey), isFalse);
      final child = $Child();
      expect(container.contains(child.$stateKey), isFalse);
      final child2 = $Child2();
      expect(container.contains(child2.$stateKey), isFalse);

      // container.put(root.$stateKey, root.createStateStream(container));
      container.put(child.$stateKey, child.createStateStream(container));
      container.put(child2.$stateKey, child2.createStateStream(container));
      await Future.delayed(Duration.zero);
      expect(container.contains(root.$stateKey), isTrue);
      expect(container.contains(child.$stateKey), isTrue);
      expect(container.contains(child2.$stateKey), isTrue);
      child.unregister(container);
      expect(container.contains(child.$stateKey), isFalse);
      child2.unregister(container);
      expect(container.contains(root.$stateKey), isFalse);
      expect(container.contains(child2.$stateKey), isFalse);
    });
    testWidgets('on widget', (widgetTester) async {
      const widget = FstateScope(child: $TestWidget());
      await widgetTester.pumpWidget(widget);
      await widgetTester.pumpAndSettle();

      final scope = find.byType(FstateScope);
      final FstateStreamContainer container =
          (widgetTester.state(scope) as dynamic).container;

      final root = $Root();
      final child = $Child();
      final child2 = $Child2();
      expect(container.contains(root.$stateKey), isTrue);
      expect(container.contains(child.$stateKey), isTrue);
      expect(container.contains(child2.$stateKey), isTrue);

      await widgetTester.pumpWidget(const SizedBox.shrink());
      expect(container.contains(root.$stateKey), isFalse);
      expect(container.contains(child.$stateKey), isFalse);
      expect(container.contains(child2.$stateKey), isFalse);
    });
  });
}

@fstate
class Root {}

@fstate
class Child {
  Child(
    @inject$Root this.root,
  );
  final Root root;
}

@fstate
class Child2 {
  Child2(
    @inject$Root this.root,
  );
  final Root root;
}

@fwidget
class TestWidget extends StatelessWidget {
  const TestWidget({
    super.key,
    @inject$Child required this.child,
    @inject$Child2 required this.child2,
    @inject$Root required this.root,
  });

  final Root root;
  final Child child;
  final Child2 child2;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
