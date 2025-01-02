import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/screens/todo_screen.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
    BlocProvider<TodoBloc>(create: (context) => TodoBloc())
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
            themeMode: state.themeMode,
            darkTheme: CustomTheme.darkTheme,
            theme: CustomTheme.lightTheme,
            home: const TodoScreen());
      },
    );
  }
}
