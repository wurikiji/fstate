> This is not production ready. Please wait for the first release.

# Fstate - Flutter-first State Management

This project is an experimental state management library
for Flutter. You can find a roadmap
[here](https://github.com/users/wurikiji/projects/2/views/1).

# Separation of State and UI

Develop state and UI separately and wire them up declaratively.

## f(state) = UI

## Declarative Dependency Injection with Reactive State

### No imperative dependency

### No imperative reactivity

## Easy timing control

## (TODO) Safe side-effect

### On lifecycle

### On Actions

# (TODO) Fstate Inspector - Easy to Debug

# (TODO) Definitely Declarative Routing - File-based routing

Router also has a state and is reactive
to the state. Flutter provides declarative routing via Router API,
but it's cumbersome to implement.

# TODO

- [x] Simple injection
- [x] Simple selector
- [x] Simple alternator
- [x] Simple widget builder
- [x] Async selector
- [x] Async action
- [x] State from the selector
- [ ] Widget life cycle
- [ ] **Isolate-based**
  - Since v3.7, flutter supports background isolate platform channels. This is a good opportunity to make fstate isolate-based.
- [ ] Family
- [ ] Error/Loading widget builder
- [ ] Error/Loading Boundary Widget
- [ ] Observer - "Side-effect"
- [ ] **Testability**
  - [ ] Overridable state
  - [ ] State only test
  - [ ] Widget test
- [ ] Reset state
- [ ] Enhance DX
  - [ ] **Without source-gen for better DX**
  - [ ] **Static State Inspector**
  - [ ] **Live State Inspector**
  - [ ] VScode extension
- [ ] **File-based routing**

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
