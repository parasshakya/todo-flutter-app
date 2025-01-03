import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:todo_app/cubits/theme_cubit/theme_state.dart';
import 'package:todo_app/cubits/todos_cubit/todos_cubit.dart';
import 'package:todo_app/cubits/todos_cubit/todos_state.dart';
import 'package:todo_app/helper.dart';
import 'package:todo_app/models/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    context.read<TodosCubit>().loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Todo App"),
          centerTitle: true,
          actions: [
            BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) => Switch(
                      value: state.themeMode == ThemeMode.dark,
                      onChanged: (value) =>
                          context.read<ThemeCubit>().changeTheme(value),
                    ))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Todo Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  controller: _controller,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      context
                          .read<TodosCubit>()
                          .addTodo(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  child: const Text("Add Todo")),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<TodosCubit, TodosState>(builder: (context, state) {
                if (state is TodosLoadInProgress || state is TodosInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is TodosLoadFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                if (state is TodosLoadComplete) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.todoItems.length,
                        itemBuilder: (context, index) {
                          final todoItem = state.todoItems[index];
                          return ListTile(
                              key: ValueKey(todoItem.id),
                              title: Text(todoItem.title),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: todoItem.isCompleted,
                                    onChanged: (value) => context
                                        .read<TodosCubit>()
                                        .toggleTodo(todoItem.id),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<TodosCubit>()
                                            .removeTodo(todoItem.id);
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ));
                        }),
                  );
                }
                return const Center(child: Text("Unexpected State"));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
