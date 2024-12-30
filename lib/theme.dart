import 'package:flutter/material.dart';

class ThemeClass {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: const ColorScheme.dark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey, // Background color for dark theme
        foregroundColor: Colors.white, // Text color for dark theme
      ),
    ),
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Background color for light theme
          foregroundColor: Colors.white, // Text color for light theme
        ),
      ),
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade200));
}
