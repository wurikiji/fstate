import 'package:fstate/fstate.dart';

import 'todo.dart';

part 'todo_store.g.dart';

@fstate
class TodoStore {
  TodoStore();

  final List<Todo> todos = [];

  @Faction()
  void add(String title) {
    todos.add(Todo(title: title));
  }

  @Faction()
  void toggle(int id) {
    final index = todos.indexWhere((todo) => todo.id == id);

    todos[index] = todos[index].toggle();
  }

  @Faction()
  void remove(int id) {
    todos.removeWhere((todo) => todo.id == id);
  }
}
