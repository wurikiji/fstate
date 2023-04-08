import 'package:fstate/fstate.dart';
import 'package:todo/src/logic/todo_store.dart';

part 'todo_store_selector.g.dart';

@Fselector()
secondTodoStoreSelector() async {
  // some initialization logic
  // to get params to build TodoStore
  await Future.delayed(const Duration(milliseconds: 500));
  // use params
  return TodoStore().toFstate();
}
