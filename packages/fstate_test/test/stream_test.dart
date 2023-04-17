import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  testWidgets('do on cancel for dart', (tester) async {
    bool called = false;
    final counter =
        Stream.periodic(const Duration(milliseconds: 1000), (i) => i)
          ..doOnCancel(() => called = true);
    print("listen");
    final subs = counter.listen(print);
    print("subed");
    await Future.delayed(Duration.zero);
    print("cancel");
    await subs.cancel();
    print("canceled");
    await Future.delayed(Duration.zero);
    expect(called, isTrue);
  }, timeout: const Timeout(Duration(milliseconds: 2000)));

  testWidgets('do on cancel for widget', (tester) async {
    bool called = false;
    final counter =
        Stream.periodic(const Duration(milliseconds: 1000), (i) => i)
          ..doOnCancel(() => called = true);
    await tester.pumpWidget(
      StreamBuilder(
        builder: (context, _) {
          return const SizedBox.shrink();
        },
        stream: counter,
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
