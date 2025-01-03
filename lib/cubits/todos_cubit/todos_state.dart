import 'package:todo_app/models/todo_item.dart';

sealed class TodosState {}

final class TodosInitial extends TodosState {
  final List<TodoItem> todoItems;

  TodosInitial({required this.todoItems});
}

final class TodosLoadInProgress extends TodosState {}

final class TodosLoadComplete extends TodosState {
  final List<TodoItem> todoItems;
  TodosLoadComplete({required this.todoItems});
}

final class TodosLoadFailure extends TodosState {
  final String errorMessage;
  TodosLoadFailure({required this.errorMessage});
}
