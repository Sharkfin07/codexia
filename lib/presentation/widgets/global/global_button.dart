import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';

class GlobalButton extends StatelessWidget {
  const GlobalButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.variant = ButtonVariant.filled,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool fullWidth;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final btnChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : child;

    final ButtonStyle style;
    switch (variant) {
      case ButtonVariant.text:
        style = TextButton.styleFrom(foregroundColor: scheme.primary);
        return _wrapWidth(
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: btnChild,
          ),
        );
      case ButtonVariant.outlined:
        style = OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
        return _wrapWidth(
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: btnChild,
          ),
        );
      case ButtonVariant.gradient:
        final radius = BorderRadius.circular(12);
        return _wrapWidth(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppPalette.blossomGradient,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: FilledButton(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: radius),
              ),
              child: btnChild,
            ),
          ),
        );
      case ButtonVariant.filled:
        style = FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
        return _wrapWidth(
          child: FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: btnChild,
          ),
        );
    }
  }

  Widget _wrapWidth({required Widget child}) {
    if (fullWidth) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}

enum ButtonVariant { filled, outlined, text, gradient }
