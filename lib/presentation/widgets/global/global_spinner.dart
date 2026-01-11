import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GlobalSpinner extends StatelessWidget {
  const GlobalSpinner({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const RiveAnimation.asset(
        'assets/animations/circle-spinner-animation-loading-animation.riv',
        fit: BoxFit.contain,
      ),
    );
  }
}
