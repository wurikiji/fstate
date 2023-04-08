> This is not production ready yet. Please wait for the first release.

# Table of Contents

- [FState - Flutter-first State Management](#fstate---flutter-first-state-management)
  - [Separation of State and UI](#separation-of-state-and-ui)
- [TODO](#todo)
- [Contributions](#contributions)
  - [Run test](#run-test)
    - [Install dependencies for tests](#install-dependencies-for-tests)
    - [Run tests](#run-tests)
    - [Coverage](#coverage)

# Separation of State and UI

## f(state) = UI

## Declarative Dependency Injection with Reactive State

### No imperative dependency

## Easy timing control

# TODO

- [x] Simple injection
  - [x] Template test
  - [x] Code Generator
- [x] Simple selector
  - [x] Template test
  - [x] Code Generator
- [x] Simple alternator
  - [x] Template test
  - [x] Code Generator
- [x] Simple widget builder
  - [x] Template test
  - [x] Code Generator
- [x] Future selector
  - [x] Code Generator
- [x] Future action
  - [x] Code Generator
- [ ] State from the selector
  - [ ] Template test
  - [ ] Code Generator
- [ ] Family
  - [ ] Template test
  - [ ] Code Generator
- [ ] Error/Loading widget builder
  - [ ] Template test
  - [ ] Code Generator
- [ ] Error Boundary Widget
- [ ] Loading Boundary Widget
- [ ] Widget life cycle
  - [ ] Template test
  - [ ] Code Generator
- [ ] Observer - "Side-effect"
  - [ ] Template test
  - [ ] Code Generator
- [ ] Testability
  - [ ] Overridable
  - [ ] State only test
  - [ ] Widget test
- [ ] Reset state
- [ ] State Debug Tool
- [ ] Enhance DX
  - [ ] hot reload

# Contributions

## Run test

### Install dependencies for tests

```bash
dart pub global activate coverage
dart pub global activate full_coverage
```

and install `lcov` and `genhtml` for coverage report.

### Run tests

Each package has `scripts/run_test.sh` to run tests.

### Coverage

# Disclaimer
