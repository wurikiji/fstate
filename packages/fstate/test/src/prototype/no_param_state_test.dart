import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

void main() {
  group('Generated no param data class', () {
    late FstateContainer container;
    setUp(() {
      container = FstateContainer();
    });
    test('has a no param builder', () {
      final generated = Generated(container: container);
      expect(
        () {
          final Target target = generated.builder();
        },
        isNot(throwsA(anything)),
      );
    });
  });
}

class Generated {
  Generated({
    required this.container,
  });
  final FstateContainer container;
  Target builder() {
    return Target();
  }
}

class Target {}
