import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';

import '../../../models/todo_param.dart';
import '../selectors/todo_store_selector.dart';

part 'todo_list_view.g.dart';

@Fwidget()
class TodoListView extends StatelessWidget {
  @Fconstructor()
  const TodoListView({
    @injectTodoParams this.todos = const [],
    super.key,
  });

  final List<TodoParam> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return $TodoTile(
          key: ValueKey('${todo.id}'),
          todo: todo,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }
}

@Fwidget()
class TodoTile extends StatelessWidget {
  @Fconstructor()
  const TodoTile({
    required this.todo,
    @injectOnToggle required this.onToggle,
    @injectOnRemove required this.onRemove,
    super.key,
  });

  final TodoParam todo;
  final void Function(int) onToggle;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) {
          onToggle(todo.id);
        },
      ),
      title: Text(todo.title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          onRemove(todo.id);
        },
      ),
    );
  }
}
