part of 'theme_bloc.dart';

sealed class ThemeEvent {}

final class ThemeToggled extends ThemeEvent {
  final bool isOn;

  ThemeToggled(this.isOn);
}
