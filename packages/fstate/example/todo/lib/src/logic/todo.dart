class Todo {
  Todo({
    int? id,
    required this.title,
    this.isDone = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  Todo toggle() {
    return Todo(
      id: id,
      title: title,
      isDone: !isDone,
    );
  }

  final int id;
  final String title;
  final bool isDone;
}
