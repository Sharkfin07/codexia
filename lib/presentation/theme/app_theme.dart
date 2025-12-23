import 'package:flutter/material.dart';
import './app_palette.dart';

class AppTheme {
  static ThemeData lightTheme() {
    print("light mode");
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
      fontFamily: 'Poppins',
    );
  }

  static ThemeData darkTheme() {
    print("dark mode");
    final scheme = ColorScheme.dark(
      primary: AppPalette.darkPink,
      secondary: AppPalette.darkPrimary,
      surface: const Color(0xFF120A2A),
      onPrimary: AppPalette.lightPrimary,
      onSecondary: AppPalette.lightPrimary,
      onSurface: AppPalette.lightPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: 'Poppins',
    );
  }
}
