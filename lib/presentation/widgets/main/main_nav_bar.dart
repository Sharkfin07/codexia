import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:codexia/presentation/screens/main/home_screen.dart';
import 'package:codexia/presentation/screens/main/profile_screen.dart';
import 'package:codexia/presentation/screens/main/rental_screen.dart';
import 'package:codexia/presentation/widgets/global/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../theme/app_palette.dart';

class MainNavBar extends ConsumerWidget {
  const MainNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileUrl = ref.read(authStateProvider).value?.photoURL;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void handleNav(int index) {
      if (index == currentIndex) return;
      final navigator = Navigator.of(context);
      final target = switch (index) {
        0 => const HomeScreen(),
        1 => const ExploreScreen(),
        2 => const RentalScreen(),
        3 => const ProfileScreen(),
        _ => const HomeScreen(),
      };

      navigator.pushReplacement(
        PageRouteBuilder(
          settings: RouteSettings(
            name: switch (index) {
              0 => '/home',
              1 => '/explore',
              2 => '/rental',
              3 => '/profile',
              _ => '/home',
            },
          ),
          pageBuilder: (_, _, _) => target,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    return Container(
      color: isDark ? AppPalette.darkSecondary : null,
      decoration: isDark
          ? null
          : const BoxDecoration(gradient: AppPalette.blossomGradient),
      padding: const EdgeInsets.all(8.0),
      child: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: AppPalette.lightPrimary,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: isDark
            ? AppPalette.darkPrimary
            : AppPalette.darkSecondary.withValues(alpha: 0.2),
        tabActiveBorder: Border.all(color: AppPalette.lightPrimary),
        color: Colors.white,
        selectedIndex: currentIndex,
        onTabChange: handleNav,
        tabs: [
          GButton(
            icon: Icons.home_max_outlined,
            leading: LogoRegular(width: 30),
            text: 'Home',
          ),
          GButton(icon: Icons.bookmark_add_outlined, text: 'Explore'),
          GButton(icon: Icons.timelapse_outlined, text: 'Rentals'),
          GButton(
            icon: Icons.person_2_outlined,
            text: 'Profile',
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppPalette.lightPrimary, width: 1.0),
              ),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: profileUrl != null && profileUrl.isNotEmpty
                    ? NetworkImage(profileUrl)
                    : null,
                child: profileUrl == null || profileUrl.isEmpty
                    ? const Icon(Icons.person, size: 14)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
