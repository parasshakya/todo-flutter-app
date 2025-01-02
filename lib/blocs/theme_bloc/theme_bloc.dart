import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeToggle>((event, emit) {
      emit(
          ThemeState(themeMode: event.isOn ? ThemeMode.dark : ThemeMode.light));
    });
  }
}
