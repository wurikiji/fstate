import 'package:fstate/fstate.dart';
import 'package:todo/src/logic/todo_store.dart';

import '../../../models/todo_param.dart';

part 'todo_store_selector.g.dart';

const injectSecondTodoStore = Finject(
  from: secondTodoStoreSelector,
);

@Fselector()
secondTodoStoreSelector() async {
  // some initialization logic
  // to get params to build TodoStore
  await Future.delayed(const Duration(milliseconds: 500));
  // use params
  return TodoStore().toFstate();
}

const injectAddTodo = Finject(from: addTodoSelector);

@Fselector()
addTodoSelector(
  @injectSecondTodoStore TodoStore store,
) {
  return store.add;
}

const injectTodoParams = Finject(from: todosFromStore);

@Fselector()
todosFromStore(
  @injectSecondTodoStore TodoStore store,
) {
  return store.todos.map((todo) {
    return TodoParam(
      id: todo.id,
      title: todo.title,
      isDone: todo.isDone,
    );
  }).toList();
}

const injectOnToggle = Finject(from: onToggleFromStore);

@Fselector()
onToggleFromStore(
  @injectSecondTodoStore TodoStore store,
) =>
    store.toggle;

const injectOnRemove = Finject(from: onRemoveFromStore);

@Fselector()
onRemoveFromStore(
  @injectSecondTodoStore TodoStore store,
) =>
    store.remove;
