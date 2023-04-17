import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test("subject", () async {
    bool called = false;
    final stream = BehaviorSubject(
      onCancel: () => called = true,
    );
    final sub = stream.listen((_) {});
    await sub.cancel();
    expect(called, isTrue);
  });
}
