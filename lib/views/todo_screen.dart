import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:todo_app/helper.dart';
import 'package:todo_app/viewModels/theme_view_model.dart';
import 'package:todo_app/schema/todo_schema.dart';
import 'package:todo_app/viewModels/todo_view_model.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(todoChangeNotifierProvider).loadTodoItems();
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
            Consumer(
                builder: (context, ref, child) => Switch.adaptive(
                      value: ref.watch(themeChangeNotifierProvider).isDarkMode,
                      onChanged: (value) => ref
                          .read(themeChangeNotifierProvider)
                          .toggleTheme(value),
                    )),
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
                      ref.read(todoChangeNotifierProvider).addTodoItem(TodoItem(
                          id: generateRandomNumber(),
                          title: _controller.text.trim(),
                          isCompleted: false));
                      _controller.clear();
                    }
                  },
                  child: const Text("Add Todo")),
              const SizedBox(
                height: 40,
              ),
              Consumer(builder: (context, ref, child) {
                final todoViewModel = ref.watch(todoChangeNotifierProvider);
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

                if (todoViewModel.todoItems.isEmpty) {
                  return const Center(
                    child: Text("No todo items found"),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoViewModel.todoItems.length,
                      itemBuilder: (context, index) {
                        final todoItem = todoViewModel.todoItems[index];
                        return ListTile(
                            key: ValueKey(todoItem.id),
                            title: Text(todoItem.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                    value: todoItem.isCompleted,
                                    onChanged: (value) =>
                                        todoViewModel.updateTodo(
                                          todoItem.copyWith(isCompleted: value),
                                        )),
                                IconButton(
                                    onPressed: () {
                                      todoViewModel.deleteTodo(todoItem);
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ));
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
