import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:todo_app/cubits/theme_cubit/theme_state.dart';
import 'package:todo_app/cubits/todos_cubit/todos_cubit.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/screens/todo_screen.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => TodosCubit())
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
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
