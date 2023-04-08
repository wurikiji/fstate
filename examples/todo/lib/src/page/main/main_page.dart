import 'package:flutter/material.dart';
import 'package:todo/src/page/second_page/second_page.dart';

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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const SecondPage();
            }),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}