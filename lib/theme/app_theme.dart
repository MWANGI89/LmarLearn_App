import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1A73E8),
    scaffoldBackgroundColor: Colors.grey[100],
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1A73E8),
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.grey[850],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
