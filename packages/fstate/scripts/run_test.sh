#!/bin/sh

## begin set up full test coverage
dart pub global run full_coverage
echo "import 'package:flutter_test/flutter_test.dart';" | cat - test/full_coverage_test.dart > temp && mv temp test/full_coverage_test.dart
gsed -i 's/{}/{ test("", () => null); }/' test/full_coverage_test.dart
## end set up full test coverage


flutter test --coverage &&
  genhtml -q -o ./coverage/html ./coverage/lcov.info &&
  lcov --list coverage/lcov.info