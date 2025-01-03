part of 'todo_bloc.dart';

sealed class TodoEvent {}

final class TodoLoaded extends TodoEvent {}

final class TodoAdded extends TodoEvent {
  final String title;

  TodoAdded(this.title);
}

final class TodoToggled extends TodoEvent {
  final String id;

  TodoToggled(this.id);
}

final class TodoDeleted extends TodoEvent {
  final String id;

  TodoDeleted(this.id);
}
