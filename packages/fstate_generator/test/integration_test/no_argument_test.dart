import 'package:flutter_test/flutter_test.dart';
import 'package:fstate/fstate.dart';

part 'no_argument_test.g.dart';

@fstate
class NoArgument {
  @constructor
  const NoArgument();
}

@fstate
class NamedConstructor {
  @constructor
  const NamedConstructor.named();
}

void main() {
  late FstateContainer container;

  setUp(() {
    container = FstateContainer();
  });

  test('With no argument', () async {
    expect($noArgument, isA<FstateKey<NoArgument>>());
    final NoArgument noArgument = $noArgument.build(container);
    container.put($noArgument, noArgument);
    final got = container.get($noArgument);
    expect(got, noArgument);
  });

  test('Use named constructor', () {
    expect($namedConstructor, isA<FstateKey<NamedConstructor>>());

    final NamedConstructor namedConstructor =
        $namedConstructor.build(container);
    container.put($namedConstructor, namedConstructor);
    final got = container.get($namedConstructor);
    expect(got, namedConstructor);
  });
}
