import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.system));

  void changeTheme(bool isOn) {
    emit(ThemeState(themeMode: isOn ? ThemeMode.dark : ThemeMode.light));
  }
}
