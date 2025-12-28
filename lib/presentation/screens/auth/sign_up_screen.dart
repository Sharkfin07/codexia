import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:codexia/presentation/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/global/global_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _isStrongPassword(String value) {
    final hasMinLength = value.length >= 8;
    final hasLetterNumber = RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(value);
    return hasMinLength && hasLetterNumber;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await notifier.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
      );
      if (mounted) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const ExploreScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final scheme = Theme.of(context).colorScheme;
    final inputFill = scheme.surface.withValues(alpha: 0.08);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
    );

    Widget title = const Text(
          'Ready to Discover Your Next Read?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 40,
            color: AppPalette.darkPink,
            height: 1,
            letterSpacing: -1,
          ),
        ),
        animatedTitle = title
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
            .slide();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  animatedTitle,
                  SizedBox(height: 20),
                  // * Name Form
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: scheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: scheme.onSurface),
                      hintStyle: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: inputFill,
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: BorderSide(
                          color: scheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Name required';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // * Email Form
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: scheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: scheme.onSurface),
                      hintStyle: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      filled: true,
                      fillColor: inputFill,
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: BorderSide(
                          color: scheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // * Password Form
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    style: TextStyle(color: scheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: scheme.onSurface),
                      hintStyle: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      helperText:
                          'Must be at least 8 chars, include letters and numbers',
                      helperStyle: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.3),
                      ),
                      filled: true,
                      fillColor: inputFill,
                      enabledBorder: border,
                      focusedBorder: border.copyWith(
                        borderSide: BorderSide(
                          color: scheme.primary,
                          width: 1.5,
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 36,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password required';
                      if (!_isStrongPassword(v)) {
                        return 'Min 8 chars with letters & numbers';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // * Submit Button
                  GlobalButton(
                    onPressed: _submit,
                    isLoading: isLoading,
                    variant: ButtonVariant.gradient,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // * Sign In Button
                  GlobalButton(
                    variant: ButtonVariant.text,
                    fullWidth: false,
                    isLoading: isLoading,
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/sign-in'),
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(color: Color(0xFFDB2777)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
