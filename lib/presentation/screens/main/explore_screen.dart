import 'package:codexia/presentation/screens/explore/filter_screen.dart';
import 'package:codexia/presentation/widgets/main/main_nav_bar.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  void _showComingSoon(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Coming soon. We are training Dex for you!'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick how you want to explore books today.',
                style: Theme.of(context).textTheme.titleMedium,
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
                title: 'Ask Dex',
                description:
                    'Answer a few questions and let Dex pick a book for you.',
                icon: Icons.chat_bubble_outline,
                accent: Colors.orangeAccent,
                onTap: () => _showComingSoon(context),
                cta: 'Chat with Dex',
              ),
              _OptionCard(
                title: 'Surprise Me',
                description:
                    'Skip filters and jump to a random book recommendation.',
                icon: Icons.auto_awesome_outlined,
                accent: Colors.purpleAccent,
                onTap: () => _showComingSoon(context),
                cta: 'Roll the Dice',
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
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
                    color: accent.withOpacity(0.1),
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
