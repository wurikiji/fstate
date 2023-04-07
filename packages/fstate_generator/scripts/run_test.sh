#!/bin/sh


## begin set up full test coverage
dart pub global activate full_coverage
dart pub global run full_coverage
echo "import 'package:test/test.dart';" | cat - test/full_coverage_test.dart > temp && mv temp test/full_coverage_test.dart
gsed -i 's/{}/{ test("", () => null); }/' test/full_coverage_test.dart
## end set up full test coverage

dart run build_runner build --delete-conflicting-outputs &&
  dart pub global activate coverage && 
  dart pub global run coverage:test_with_coverage --branch-coverage --function-coverage -- test/src test/unit_test test/full_coverage_test.dart &&
    genhtml -q -o ./coverage/html ./coverage/lcov.info &&
    lcov --list coverage/lcov.info 


# flutter test --coverage --branch-coverage &&
# dart pub global run coverage:test_with_coverage --branch-coverage --function-coverage &&