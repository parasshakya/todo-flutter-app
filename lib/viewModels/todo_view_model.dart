import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/schema/todo_schema.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoModel todoModel;

  TodoViewModel({required this.todoModel});

  List<TodoItem> _todoItems = [];

  List<TodoItem> get todoItems => _todoItems;

  bool loading = true;

  bool error = false;

  addTodoItem(TodoItem todoItem) {
    _todoItems.add(todoItem);
    notifyListeners();
  }

  loadTodoItems() async {
    loading = true;
    error = false;
    notifyListeners();

    try {
      _todoItems = await todoModel.getTodoItems();
    } catch (e) {
      error = true;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  deleteTodo(TodoItem todoItem) {
    _todoItems.removeWhere((element) => element.id == todoItem.id);
    notifyListeners();
  }

  updateTodo(TodoItem todoItem) {
    int index = todoItems.indexWhere((element) => element.id == todoItem.id);

    if (index != -1) {
      _todoItems[index] = todoItem;
      notifyListeners();
    }
  }
}

final todoNotifierProvider = ChangeNotifierProvider<TodoViewModel>((ref) {
  return TodoViewModel(todoModel: TodoModel());
});
