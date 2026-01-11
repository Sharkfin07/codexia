import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:codexia/presentation/widgets/auth/login_animation.dart';
import 'package:codexia/presentation/widgets/global/global_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SingleTickerProviderStateMixin {
  double _opacityLevel = 0.0;
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  LoginAnimationController? _anim;
  bool _obscure = true;
  late final AnimationController _welcomeCtrl;
  late final Animation<double> _welcomeFade;
  late final Animation<double> _welcomeScale;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleEmailFocus);
    _passwordFocus.addListener(_handlePasswordFocus);

    // * Example case of the Animation Controller
    _welcomeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // * Example case of the Curved Animation
    _welcomeFade = CurvedAnimation(parent: _welcomeCtrl, curve: Curves.easeIn);
    _welcomeScale = CurvedAnimation(
      parent: _welcomeCtrl,
      curve: Curves.easeOutBack,
    );

    // Fade-in effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacityLevel = 1.0;
      });
      _welcomeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.removeListener(_handleEmailFocus);
    _passwordFocus.removeListener(_handlePasswordFocus);
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _welcomeCtrl.dispose();
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
      _anim?.success();
      if (mounted) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const ExploreScreen()),
        );
      }
    } catch (e) {
      _anim?.fail();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _handleEmailFocus() {
    if (_emailFocus.hasFocus) {
      _anim?.setChecking(true);
      _anim?.setHandsUp(false);
    }
  }

  void _handlePasswordFocus() {
    if (_passwordFocus.hasFocus) {
      _anim?.setHandsUp(true);
      _anim?.setChecking(false);
    } else {
      _anim?.setHandsUp(false);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // * Example case of the Animation Controller
                      FadeTransition(
                        opacity: _welcomeFade,
                        child: ScaleTransition(
                          scale: _welcomeScale,
                          child: const Text(
                            "Welcome to Codexia!",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // * Example case of Rive Animations
                      LoginAnimation(onControllerReady: (ctrl) => _anim = ctrl),

                      SizedBox(height: 36),

                      // * Email Form
                      TextFormField(
                        controller: _emailCtrl,
                        focusNode: _emailFocus,
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
                        onChanged: (v) {
                          _anim?.setChecking(true);
                          _anim?.lookAt(v.length.toDouble());
                        },
                      ),

                      const SizedBox(height: 12),

                      // * Password Form
                      TextFormField(
                        controller: _passwordCtrl,
                        focusNode: _passwordFocus,
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
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Password required';
                          if (v.length < 8) return 'Min 8 characters';
                          return null;
                        },
                      ),

                      const SizedBox(height: 5),

                      // * Forgot Password Button
                      // * Animated Opacity Example
                      AnimatedOpacity(
                        opacity: _opacityLevel,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GlobalButton(
                            variant: ButtonVariant.text,
                            fullWidth: false,
                            child: Text(
                              "Forgot Password?",
                              style: const TextStyle(color: Color(0xFFDB2777)),
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/forgot-password',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // * Submit Button with AnimatedContainer
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutExpo,
                        width: double.infinity,
                        height: isLoading ? 46 : 56,
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isLoading ? 30 : 14,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withValues(alpha: 0.35),
                              blurRadius: isLoading ? 4 : 18,
                              spreadRadius: isLoading ? 0 : 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: GlobalButton(
                          onPressed: _submit,
                          isLoading: isLoading,
                          variant: ButtonVariant.gradient,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // * Sign Up Button
                      // * Animated Opacity Example
                      AnimatedOpacity(
                        opacity: _opacityLevel,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn,
                        child: GlobalButton(
                          variant: ButtonVariant.text,
                          fullWidth: false,
                          isLoading: isLoading,
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/sign-up',
                          ),
                          child: Text(
                            "Don't have an account? Sign Up",
                            style: const TextStyle(color: Color(0xFFDB2777)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
