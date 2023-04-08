import 'package:flutter/material.dart';
import 'package:fstate/fstate.dart';
import 'package:todo/src/page/second_page/selectors/todo_store_selector.dart';

part 'todo_input_field.g.dart';

@Fwidget()
class TodoInputField extends StatelessWidget {
  @Fconstructor()
  const TodoInputField({
    @injectAddTodo required this.addTodo,
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
