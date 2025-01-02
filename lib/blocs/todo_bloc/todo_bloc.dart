import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo.dart';
part "todo_event.dart";
part "todo_state.dart";

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    // Load Todos
    on<LoadTodos>((event, emit) async {
      emit(TodoInitial()); // Emit initial state while loading
      try {
        // Fetch todos from JSONPlaceholder
        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final todos = data.map((todo) {
            return Todo(
              id: todo['id'].toString(),
              title: todo['title'],
              isCompleted: todo['completed'],
            );
          }).toList();

          emit(TodoLoaded(todos));
        } else {
          emit(TodoError('Failed to load todos.'));
        }
      } catch (e) {
        emit(TodoError('An error occurred: $e'));
      }
    });

    // Add Todo
    on<AddTodo>((event, emit) {
      if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;
        final newTodo = Todo(
          id: DateTime.now().toString(),
          title: event.title,
        );
        emit(TodoLoaded([...currentState.todos, newTodo]));
      }
    });

    // Toggle Todo
    on<ToggleTodo>((event, emit) {
      if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;
        final updatedTodos = currentState.todos.map((todo) {
          if (todo.id == event.id) {
            return todo.copyWith(isCompleted: !todo.isCompleted);
          }
          return todo;
        }).toList();
        emit(TodoLoaded(updatedTodos));
      }
    });

    // Delete Todo
    on<DeleteTodo>((event, emit) {
      if (state is TodoLoaded) {
        final currentState = state as TodoLoaded;
        final updatedTodos =
            currentState.todos.where((todo) => todo.id != event.id).toList();
        emit(TodoLoaded(updatedTodos));
      }
    });
  }
}
