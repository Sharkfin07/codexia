import 'package:codexia/presentation/screens/auth/forgot_password_screen.dart';
import 'package:codexia/presentation/screens/auth/sign_in_screen.dart';
import 'package:codexia/presentation/screens/auth/sign_up_screen.dart';
import 'package:codexia/presentation/theme/app_theme.dart';
import 'package:codexia/presentation/screens/explore/explore_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/sign-in',
      routes: {
        '/': (context) => const ExploreScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
