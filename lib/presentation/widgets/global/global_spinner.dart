import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlobalSpinner extends StatefulWidget {
  const GlobalSpinner({super.key, this.size = 64});

  final double size;

  @override
  State<GlobalSpinner> createState() => _GlobalSpinnerState();
}

class _GlobalSpinnerState extends State<GlobalSpinner>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.asset(
        'assets/animations/loading_lottie.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = const Duration(milliseconds: 600)
            ..forward();
        },
      ),
    );
  }
}
