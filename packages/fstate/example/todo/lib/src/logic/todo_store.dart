import 'package:fstate/fstate.dart';

import 'todo.dart';

part 'todo_store.g.dart';

@Fstate()
class TodoStore {
  @Fconstructor()
  TodoStore();

  final List<Todo> todos = [];

  @Faction()
  void add(String title) {
    todos.add(Todo(title: title));
  }

  @Faction()
  void toggle(int id) {
    final todo = todos.firstWhere((todo) => todo.id == id);
    final index = todos.indexOf(todo);
    todos[index] = Todo(title: todo.title, isDone: !todo.isDone);
  }

  @Faction()
  void remove(int id) {
    todos.removeWhere((todo) => todo.id == id);
  }
}
