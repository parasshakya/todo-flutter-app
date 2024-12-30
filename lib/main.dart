import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/theme_view_model.dart';
import 'package:todo_app/todo_model.dart';
import 'package:todo_app/todo_screen.dart';
import 'package:todo_app/todo_view_model.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => TodoViewModel(todoModel: TodoModel()),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeViewModel(),
    ),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return MaterialApp(
        themeMode: themeViewModel.themeMode,
        darkTheme: ThemeClass.darkTheme,
        theme: ThemeClass.lightTheme,
        home: const TodoScreen());
  }
}
