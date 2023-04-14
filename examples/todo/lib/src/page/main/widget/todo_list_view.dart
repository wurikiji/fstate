import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';

import '../../../logic/todo_store.dart';
import '../../../models/todo_param.dart';

part 'todo_list_view.g.dart';

@fstate
todosFromStore(
  @inject$TodoStore TodoStore store,
) {
  return store.todos.map((todo) {
    return TodoParam(
      id: todo.id,
      title: todo.title,
      isDone: todo.isDone,
    );
  }).toList();
}

@fwidget
class TodoListView extends StatelessWidget {
  const TodoListView({
    @inject$todosFromStore this.todos = const [],
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

@fstate
onToggleFromStore(
  @inject$TodoStore TodoStore store,
) =>
    store.toggle;

@fstate
onRemoveFromStore(
  @inject$TodoStore TodoStore store,
) =>
    store.remove;

@fwidget
class TodoTile extends StatelessWidget {
  const TodoTile({
    required this.todo,
    @inject$onToggleFromStore required this.onToggle,
    @inject$onRemoveFromStore required this.onRemove,
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
