part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ThemeToggle extends ThemeEvent {
  final bool isOn;

  ThemeToggle(this.isOn);
}
