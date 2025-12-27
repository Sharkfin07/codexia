import 'package:flutter/material.dart';

class LogoRegular extends StatelessWidget {
  final double? width;
  final bool forceDark;
  const LogoRegular({super.key, this.width = 35, this.forceDark = false});

  @override
  Widget build(BuildContext context) {
    final isDark = forceDark
        ? true
        : Theme.of(context).brightness == Brightness.dark;
    final imgPath =
        'assets/images/codexia-logo-${isDark ? 'dark' : 'light'}.png';
    return Image.asset(imgPath, width: width);
  }
}
