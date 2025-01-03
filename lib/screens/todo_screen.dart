import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/screens/IncompleteTodosScreen.dart';
import 'package:todo_app/screens/completedTodosScreen.dart';

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
    context.read<TodoBloc>().add(TodoLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App with BLoC'),
        actions: [
          // DropdownButton<String>(
          //   hint: const Text('Select Todo List'),
          //   onChanged: (value) {
          //     if (value == 'Completed') {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => const CompletedTodosScreen()),
          //       );
          //     } else if (value == 'Incomplete') {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => const IncompleteTodosScreen()),
          //       );
          //     }
          //   },
          //   items: const [
          //     DropdownMenuItem<String>(
          //       value: 'Completed',
          //       child: Text('Completed Todos'),
          //     ),
          //     DropdownMenuItem<String>(
          //       value: 'Incomplete',
          //       child: Text('Incomplete Todos'),
          //     ),
          //   ],
          // ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Switch(
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (isDarkMode) {
                    context.read<ThemeBloc>().add(ThemeToggled(isDarkMode));
                  });
            },
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          // if (state is TodoInitial) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          if (state is TodoLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodoLoadFailure) {
            return Center(child: Text(state.message));
          }
          if (state is TodoLoadSuccess) {
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
                      context.read<TodoBloc>().add(TodoToggled(todo.id));
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TodoBloc>().add(TodoDeleted(todo.id));
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
                        context
                            .read<TodoBloc>()
                            .add(TodoAdded(controller.text));
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
