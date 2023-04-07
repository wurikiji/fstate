import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:todo/src/logic/todo_store.dart';

part 'todo_list_view.g.dart';

class TodoParam {
  const TodoParam({
    required this.id,
    required this.title,
    required this.isDone,
  });

  final int id;
  final String title;
  final bool isDone;
}

@Fselector()
todosFromStore(
  @Finject() TodoStore store,
) {
  return store.todos.map((todo) {
    return TodoParam(
      id: todo.id,
      title: todo.title,
      isDone: todo.isDone,
    );
  }).toList();
}

@Fwidget()
class TodoListView extends StatelessWidget {
  @Fconstructor()
  const TodoListView({
    @Finject(derivedFrom: todosFromStore) this.todos = const [],
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

@Fselector()
onToggleFromStore(
  @Finject() TodoStore store,
) =>
    store.toggle;

@Fselector()
onRemoveFromStore(
  @Finject() TodoStore store,
) =>
    store.remove;

@Fwidget()
class TodoTile extends StatelessWidget {
  @Fconstructor()
  const TodoTile({
    required this.todo,
    @Finject(derivedFrom: onToggleFromStore) required this.onToggle,
    @Finject(derivedFrom: onRemoveFromStore) required this.onRemove,
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
