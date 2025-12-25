import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("This is the Home Screen"))),
      bottomNavigationBar: MainNavBar(currentIndex: 0),
    );
  }
}
