import 'package:flutter/material.dart';

import 'widget/todo_input_field.dart';
import 'widget/todo_list_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            $TodoInputField(),
            Expanded(
              child: $TodoListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (context as Element).markNeedsBuild();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
