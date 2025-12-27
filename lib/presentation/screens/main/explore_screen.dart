import 'package:codexia/presentation/screens/explore/filter_screen.dart';
import 'package:codexia/presentation/screens/explore/surprise_me_loading_screen.dart';
import 'package:codexia/presentation/theme/app_palette.dart';
import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language_rounded, size: 40, weight: 10),
                SizedBox(height: 10),
                Text(
                  'Pick how you want to explore books today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 16),
                _OptionCard(
                  title: 'Filter',
                  description:
                      'Narrow down by genre, keyword, year, and page, then sort the results.',
                  icon: Icons.tune_outlined,
                  accent: Colors.blueAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FilterScreen()),
                    );
                  },
                  cta: 'Open Filters',
                ),
                _OptionCard(
                  title: 'Surprise Me',
                  description:
                      'Skip filters and jump to a random book recommendation.',
                  icon: Icons.auto_awesome_outlined,
                  accent: Colors.purpleAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SurpriseMeLoadingScreen(),
                      ),
                    );
                  },
                  cta: 'Roll the Dice',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MainNavBar(currentIndex: 1),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.onTap,
    required this.cta,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final String cta;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: isDark ? AppPalette.darkSecondary : AppPalette.lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cta,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
