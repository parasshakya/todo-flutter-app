import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the LoadTodos event when the screen initializes
    context.read<TodoBloc>().add(LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App with BLoC'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Switch(
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (isDarkMode) {
                    context.read<ThemeBloc>().add(ThemeToggle(isDarkMode));
                  });
            },
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) {
                      context.read<TodoBloc>().add(ToggleTodo(todo.id));
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(DeleteTodo(todo.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Unexpected state!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add Todo'),
                content: TextField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        context.read<TodoBloc>().add(AddTodo(controller.text));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
