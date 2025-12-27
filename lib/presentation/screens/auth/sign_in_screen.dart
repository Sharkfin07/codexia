import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:codexia/presentation/widgets/global/global_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await notifier.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
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
                      if (v.length < 8) return 'Min 8 characters';
                      return null;
                    },
                  ),

                  const SizedBox(height: 5),

                  // * Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlobalButton(
                      variant: ButtonVariant.text,
                      fullWidth: false,
                      child: Text(
                        "Forgot Password?",
                        style: const TextStyle(color: Color(0xFFDB2777)),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/forgot-password'),
                    ),
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // * Sign Up Button
                  GlobalButton(
                    variant: ButtonVariant.text,
                    fullWidth: false,
                    isLoading: isLoading,
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/sign-up'),
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: const TextStyle(color: Color(0xFFDB2777)),
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
