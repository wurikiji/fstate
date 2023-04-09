import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';

import '../../../logic/todo_store.dart';

part 'todo_input_field.g.dart';

@fstate
addTodoSelector(
  @inject$TodoStore TodoStore store,
) {
  return store.add;
}

@fwidget
class TodoInputField extends StatelessWidget {
  const TodoInputField({
    @inject$addTodoSelector required this.addTodo,
    super.key,
  });

  final void Function(String) addTodo;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: addTodo,
    );
  }
}
