class Todo {
  Todo({
    required this.title,
    this.isDone = false,
  });

  final int id = DateTime.now().millisecondsSinceEpoch;
  final String title;
  final bool isDone;
}
