part of 'todo_bloc.dart';

sealed class TodoState {}

final class TodoInitial extends TodoState {
  final List<Todo> todos;

  TodoInitial({required this.todos});
}

final class TodoLoadInProgress extends TodoState {}

final class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;

  TodoLoadSuccess(this.todos);
}

final class TodoLoadFailure extends TodoState {
  final String message;

  TodoLoadFailure(this.message);
}
