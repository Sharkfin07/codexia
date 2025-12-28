import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/theme/app_palette.dart';
import 'package:codexia/presentation/widgets/global/logo.dart';
import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.value;
    final displayName = user?.displayName;
    final emailFirst = _firstWordFromEmail(user?.email);
    final now = DateTime.now();
    final greeting = _greetingFor(now.hour);
    final firstName = _firstWord(displayName) ?? emailFirst ?? 'there';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoRegular(width: 100, mode: LogoVariants.dark),
                SizedBox(height: 18),
                Text(
                  '$greeting, $firstName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 6),
                Opacity(
                  opacity: 0.5,
                  child: const Text(
                    'Welcome back to Codexia!\nPick a path to start exploring.',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: 'Quick Explore',
                        subtitle: 'Filter books fast!',
                        icon: Icons.explore_outlined,
                        gradient: const [
                          AppPalette.darkPink,
                          AppPalette.darkSecondary,
                        ],
                        onTap: () =>
                            Navigator.of(context).pushNamed('/explore/filter'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'My Rentals',
                        subtitle: 'Manage your rentals',
                        icon: Icons.event_note_outlined,
                        gradient: const [
                          AppPalette.darkSecondary,
                          AppPalette.darkPink,
                        ],
                        onTap: () => Navigator.of(context).pushNamed('/rental'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'My Wishlist',
                        subtitle: 'Saved favorites',
                        icon: Icons.favorite_outline,
                        gradient: const [
                          AppPalette.darkPink,
                          AppPalette.darkSecondary,
                        ],
                        onTap: () =>
                            Navigator.of(context).pushNamed('/wishlist'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainNavBar(currentIndex: 0),
    );
  }

  String _greetingFor(int hour) {
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String? _firstWord(String? name) {
    if (name == null) return null;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split(' ');
    return parts.first;
  }

  String? _firstWordFromEmail(String? email) {
    if (email == null || email.isEmpty) return null;
    final local = email.split('@').first;
    return _firstWord(local);
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
