import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/todos_cubit/todos_state.dart';
import 'package:todo_app/models/todo_item.dart';
import "package:http/http.dart" as http;

class TodosCubit extends Cubit<TodosState> {
  TodosCubit() : super(TodosInitial(todoItems: []));

  Future<void> loadTodos() async {
    emit(TodosLoadInProgress());
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final todoItems = data.map((e) => TodoItem.fromJson(e)).toList();
        emit(TodosLoadComplete(todoItems: todoItems));
      }
    } catch (e) {
      emit(TodosLoadFailure(errorMessage: e.toString()));
    }
  }

  @override
  void onChange(Change<TodosState> change) {
    print(change);
    super.onChange(change);
  }

  void addTodo(String title) {
    if (state is TodosLoadComplete) {
      final currentState = state as TodosLoadComplete;

      final newTodo =
          TodoItem(id: DateTime.now().millisecondsSinceEpoch, title: title);

      currentState.todoItems.add(newTodo);
      emit(TodosLoadComplete(todoItems: currentState.todoItems));
    }
  }

  void removeTodo(int id) {
    if (state is TodosLoadComplete) {
      final currentState = state as TodosLoadComplete;
      currentState.todoItems.removeWhere((element) => element.id == id);
      emit(TodosLoadComplete(todoItems: currentState.todoItems));
    }
  }

  void toggleTodo(int id) {
    if (state is TodosLoadComplete) {
      final currentState = state as TodosLoadComplete;
      final updatedTodos = currentState.todoItems.map((todoItem) {
        if (todoItem.id == id) {
          return todoItem.copyWith(isCompleted: !todoItem.isCompleted);
        }
        return todoItem;
      }).toList();

      emit(TodosLoadComplete(todoItems: updatedTodos));
    }
  }
}
