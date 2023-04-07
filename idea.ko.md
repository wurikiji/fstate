# 목표

목표는 f(state) = UI 를 실현하는 것이다.

- Widget 에는 온전히 UI (View) 코드만 존재하도록 한다.

  - Mutable State 를 갖지 않는다.
  - State Mutation 작업을 수행하지 않는다.
    - State key 와 State Mutator 를 별도로 정의한다.
  - State Selection 작업을 수행하지 않는다.

- State 에는 온전히 State 코드만 존재하도록 한다.

  - Entity 로써의 역할

- Side Effect 는 별도로 정의한다.
  - 완전히 다른 패키지에 정의 가능해야 한다.

# 구성

## State

- Container -> State 를 저장하는 역할
- State -> Container 에 저장되는 상태
- StateKey -> Container 에서 state 를 구분하는 역할
- StateMutator -> State 를 변경하고 Container 에 저장하는 역할
- StateSelector -> State 를 선택하는 역할
- StateObserver -> Side effect 를 수행하는 역할

## UI

- Widget -> UI 를 표현하는 역할
- StateProvider -> Container scoping
