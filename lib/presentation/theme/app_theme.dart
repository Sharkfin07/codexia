import 'package:flutter/material.dart';
import './app_palette.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final scheme = ColorScheme.light(
      primary: AppPalette.lightPrimary,
      secondary: AppPalette.lightSecondary,
      surface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
    );
  }

  static ThemeData darkTheme() {
    final scheme = ColorScheme.dark(
      primary: AppPalette.darkPrimary,
      secondary: AppPalette.darkSecondary,
      surface: const Color(0xFF120A2A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
    );
  }
}
