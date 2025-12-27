import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/auth/forgot_password_screen.dart';
import 'package:codexia/presentation/screens/auth/sign_in_screen.dart';
import 'package:codexia/presentation/screens/auth/sign_up_screen.dart';
import 'package:codexia/presentation/screens/auth/edit_profile_screen.dart';
import 'package:codexia/presentation/screens/auth/reset_password_screen.dart';
import 'package:codexia/presentation/screens/books/book_detail.dart';
import 'package:codexia/presentation/screens/explore/filter_screen.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:codexia/presentation/screens/main/home_screen.dart';
import 'package:codexia/presentation/screens/main/profile_screen.dart';
import 'package:codexia/presentation/screens/main/rental_screen.dart';
import 'package:codexia/presentation/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: authState.when(
        data: (user) =>
            user != null ? const HomeScreen() : const SignInScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
      ),
      routes: {
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/profile/edit': (context) => const EditProfileScreen(),
        '/profile/reset-password': (context) => const ResetPasswordScreen(),
        '/rental': (context) => const RentalScreen(),
        '/explore': (context) => const ExploreScreen(),
        '/explore/filter': (context) => const FilterScreen(),
        '/books/detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return BookDetailScreen.fromRoute(args);
        },
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
