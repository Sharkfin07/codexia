// * Widget Testing 2: Explore Screen Integrity Test
import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ExploreScreen shows available explore options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => const Stream<User?>.empty()),
        ],
        child: const MaterialApp(home: ExploreScreen()),
      ),
    );

    expect(
      find.text('Pick how you want to explore books today.'),
      findsOneWidget,
    );
    expect(find.text('Open Filters'), findsOneWidget);
    expect(find.text('Roll the Dice'), findsOneWidget);
    expect(find.byIcon(Icons.tune_outlined), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
  });
}
