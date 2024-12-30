import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/helper.dart';
import 'package:todo_app/viewModels/theme_view_model.dart';
import 'package:todo_app/schema/todo_schema.dart';
import 'package:todo_app/viewModels/todo_view_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TodoViewModel>().loadTodoItems();
    });

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
            Consumer<ThemeViewModel>(
                builder: (context, themeViewModel, child) => Switch.adaptive(
                      value: themeViewModel.isDarkMode,
                      onChanged: (value) => themeViewModel.toggleTheme(value),
                    ))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
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
                    context.read<TodoViewModel>().addTodoItem(TodoItem(
                        id: generateRandomNumber(),
                        title: _controller.text.trim(),
                        isCompleted: false));
                    _controller.clear();
                  },
                  child: const Text("Add Todo")),
              Consumer<TodoViewModel>(builder: (context, todoViewModel, child) {
                if (todoViewModel.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (todoViewModel.error) {
                  return const Text(
                      "Something went wrong, Please try again later");
                }
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoViewModel.todoItems.length,
                      itemBuilder: (context, index) {
                        final todoItem = todoViewModel.todoItems[index];
                        return ListTile(
                            title: Text(todoItem.title),
                            trailing: Checkbox(
                                value: todoItem.isCompleted,
                                onChanged: (value) => todoViewModel.updateTodo(
                                      todoItem.copyWith(isCompleted: value),
                                    )));
                      }),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
