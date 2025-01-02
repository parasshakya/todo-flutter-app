import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/schema/todo_schema.dart';

class TodoModel {
  Future<List<TodoItem>> getTodoItems() async {
    List<TodoItem> todoItems = [];

    await Future.delayed(
      const Duration(seconds: 2),
      () {
        todoItems = [
          TodoItem(id: 1, title: "Complete homework", isCompleted: false),
          TodoItem(id: 2, title: "Wash dishes", isCompleted: true),
          TodoItem(id: 3, title: "Wash clothes", isCompleted: true),
          TodoItem(id: 4, title: "Clean room", isCompleted: true),
        ];
      },
    );

    return todoItems;
  }
}

final todoItemsProvider = FutureProvider<List<TodoItem>>((ref) async {
  List<TodoItem> todoItems = [];

  await Future.delayed(
    const Duration(seconds: 2),
    () {
      todoItems = [
        TodoItem(id: 1, title: "Complete homework", isCompleted: false),
        TodoItem(id: 2, title: "Wash dishes", isCompleted: true),
        TodoItem(id: 3, title: "Wash clothes", isCompleted: true),
        TodoItem(id: 4, title: "Clean room", isCompleted: true),
      ];
    },
  );

  return todoItems;
});
