import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/viewModels/theme_view_model.dart';
import 'package:todo_app/views/todo_screen.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeViewModel = ref.watch(themeChangeNotifierProvider);
    return MaterialApp(
        themeMode: themeViewModel.themeMode,
        darkTheme: CustomTheme.darkTheme,
        theme: CustomTheme.lightTheme,
        home: const TodoScreen());
  }
}
