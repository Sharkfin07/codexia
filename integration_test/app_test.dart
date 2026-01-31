// Integration test flow:
// 1) Buka Explore screen
// 2) Tap “Open Filters” untuk berpindah halaman FilterScreen.
// 3) Verifikasi
// Connect device/emulator, lalu jalankan `flutter test integration_test`

import 'package:codexia/presentation/providers/auth_provider.dart';
import 'package:codexia/presentation/screens/explore/filter_screen.dart';
import 'package:codexia/presentation/screens/main/explore_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Explore flow: open filter screen and return', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Avoid hitting real Firebase auth; keep auth state empty.
          authStateProvider.overrideWith((ref) => const Stream<User?>.empty()),
        ],
        child: const MaterialApp(home: ExploreScreen()),
      ),
    );

    // On Explore screen
    expect(
      find.text('Pick how you want to explore books today.'),
      findsOneWidget,
    );
    expect(find.text('Open Filters'), findsOneWidget);

    // Tap Filter option -> navigates to FilterScreen
    await tester.tap(find.text('Open Filters'));
    await tester.pumpAndSettle();

    expect(find.byType(FilterScreen), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);

    // Back to Explore
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(ExploreScreen), findsOneWidget);
  });
}
