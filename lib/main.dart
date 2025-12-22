import 'package:codexia/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:codexia/presentation/screens/explore/explore_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {'/': (context) => const ExploreScreen()},
    );
  }
}
