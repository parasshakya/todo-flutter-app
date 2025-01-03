import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';

class CompletedTodosScreen extends StatelessWidget {
  const CompletedTodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, todoState) {
          if (todoState is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoState is TodoLoadFailure) {
            return Center(child: Text(todoState.message));
          }

          if (todoState is TodoLoadSuccess) {
            final completedTodos =
                todoState.todos.where((todo) => todo.isCompleted).toList();
            return ListView.builder(
              itemCount: completedTodos.length,
              itemBuilder: (context, index) {
                final todo = completedTodos[index];
                return ListTile(
                  title: Text(todo.title),
                );
              },
            );
          }

          return const Center(child: Text('Unexpected state!'));
        },
      ),
    );
  }
}
