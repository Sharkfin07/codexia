import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/repositories/book_repository.dart';
import '../books/book_detail_screen.dart';

class SurpriseMeLoadingScreen extends StatefulWidget {
  const SurpriseMeLoadingScreen({super.key});

  @override
  State<SurpriseMeLoadingScreen> createState() =>
      _SurpriseMeLoadingScreenState();
}

class _SurpriseMeLoadingScreenState extends State<SurpriseMeLoadingScreen> {
  final BookRepository _repo = BookRepository();
  Timer? _delayTimer;
  bool _navigated = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startRoll();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void _startRoll() {
    setState(() => _error = null);
    _delayTimer?.cancel();

    _delayTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        final book = await _repo.fetchRandomBook();
        if (!mounted || _navigated) return;
        _navigated = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BookDetailScreen(id: book.id, initialBook: book),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        setState(() => _error = e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Rolling the dice...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              const _Dots(),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _startRoll,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  const _Dots();

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // * Animation Controller Example
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final dots = [0, 1, 2]
            .map(
              (i) => Opacity(
                opacity: ((value + i / 3) % 1).clamp(0.2, 1.0),
                child: const Text(
                  '•',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
            .toList();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: dots
              .expand((dot) => [dot, const SizedBox(width: 6)])
              .toList()
              .sublist(0, dots.length * 2 - 1),
        );
      },
    );
  }
}
