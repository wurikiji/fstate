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

### No imperative reactivity

## Easy timing control

## (TODO) Safe side-effect

### On lifecycle

### On Actions

# (TODO) Fstate Inspector - Easy to Debug

# (TODO) Definitely Declarative Routing - File-based

# TODO

- [x] Simple injection
- [x] Simple selector
- [x] Simple alternator
- [x] Simple widget builder
- [x] Async selector
- [x] Async action
- [x] State from the selector
- [ ] Family
- [ ] Error/Loading widget builder
- [ ] Error Boundary Widget
- [ ] Loading Boundary Widget
- [ ] Widget life cycle
- [ ] Observer - "Side-effect"
- [ ] Testability
  - [ ] Overridable
  - [ ] State only test
  - [ ] Widget test
- [ ] Reset state
- [ ] Enhance DX
  - [ ] hot reload
  - [ ] State Inspector
- [ ] File-based routing

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
