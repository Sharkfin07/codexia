import 'package:flutter/material.dart';

class LogoRegular extends StatelessWidget {
  final double? width;
  final LogoVariants mode;
  const LogoRegular({
    super.key,
    this.width = 35,
    this.mode = LogoVariants.auto,
  });

  @override
  Widget build(BuildContext context) {
    final String imgPath;
    switch (mode) {
      case LogoVariants.light:
        imgPath = 'assets/images/codexia-logo-light.png';
        break;
      case LogoVariants.dark:
        imgPath = 'assets/images/codexia-logo-dark.png';
        break;
      case LogoVariants.alt:
        imgPath = 'assets/images/codexia-logo-alt.png';
        break;
      default:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        imgPath = 'assets/images/codexia-logo-${isDark ? 'dark' : 'light'}.png';
    }
    return Image.asset(imgPath, width: width);
  }
}

class LogoTypography extends StatelessWidget {
  final double? width;
  final LogoVariants mode;
  const LogoTypography({
    super.key,
    this.width = 35,
    this.mode = LogoVariants.auto,
  });

  @override
  Widget build(BuildContext context) {
    final String imgPath;
    switch (mode) {
      case LogoVariants.light:
        imgPath = 'assets/images/codexia-logo-typ-light.png';
        break;
      case LogoVariants.dark:
        imgPath = 'assets/images/codexia-logo-typ-dark.png';
        break;
      case LogoVariants.alt:
        imgPath = 'assets/images/codexia-logo-typ-light.png';
        break;
      default:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        imgPath =
            'assets/images/codexia-logo-typ-${isDark ? 'dark' : 'light'}.png';
    }
    return Image.asset(imgPath, width: width);
  }
}

enum LogoVariants { dark, light, alt, auto }
