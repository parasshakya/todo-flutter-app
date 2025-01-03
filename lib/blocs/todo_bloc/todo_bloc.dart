import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo.dart';
part "todo_event.dart";
part "todo_state.dart";

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial(todos: [])) {
    // Load Todos
    on<TodoLoaded>(_onTodoLoaded);

    // Add Todo
    on<TodoAdded>(_onTodoAdded);

    // Toggle Todo
    on<TodoToggled>(_onTodoToggled);

    // Delete Todo
    on<TodoDeleted>(_onTodoDeleted);
  }

  @override
  void onTransition(Transition<TodoEvent, TodoState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  _onTodoLoaded(TodoLoaded event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoadInProgress());
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

        emit(TodoLoadSuccess(todos));
      } else {
        emit(TodoLoadFailure('Failed to load todos.'));
      }
    } catch (e) {
      emit(TodoLoadFailure('An error occurred: $e'));
    }
  }

  _onTodoAdded(TodoAdded event, Emitter<TodoState> emit) {
    if (state is TodoLoadSuccess) {
      final currentState = state as TodoLoadSuccess;
      final newTodo = Todo(
        id: DateTime.now().toString(),
        title: event.title,
      );
      emit(TodoLoadSuccess([...currentState.todos, newTodo]));
    }
  }

  _onTodoToggled(TodoToggled event, Emitter<TodoState> emit) {
    if (state is TodoLoadSuccess) {
      final currentState = state as TodoLoadSuccess;
      final updatedTodos = currentState.todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();
      emit(TodoLoadSuccess(updatedTodos));
    }
  }

  _onTodoDeleted(TodoDeleted event, Emitter<TodoState> emit) {
    if (state is TodoLoadSuccess) {
      final currentState = state as TodoLoadSuccess;
      final updatedTodos =
          currentState.todos.where((todo) => todo.id != event.id).toList();
      emit(TodoLoadSuccess(updatedTodos));
    }
  }
}
