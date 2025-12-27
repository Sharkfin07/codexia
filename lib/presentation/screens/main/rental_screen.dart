import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';

class RentalScreen extends StatelessWidget {
  const RentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("This is the Rental Screen!"))),
      bottomNavigationBar: MainNavBar(currentIndex: 2),
    );
  }
}
