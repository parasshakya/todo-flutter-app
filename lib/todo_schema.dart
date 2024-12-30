class TodoItem {
  int id;
  String title;
  bool isCompleted;

  TodoItem({required this.id, required this.title, required this.isCompleted});

  TodoItem copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
