// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter_test/flutter_test.dart';

import 'package:times/main.dart';
import 'package:times/pages/splash_screen.dart';

import 'package:provider/provider.dart';
import 'package:times/provider/glass_provider.dart';
import 'package:times/provider/key_animator.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => KeyAnimator()),
          ChangeNotifierProvider(create: (_) => GlassProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the splash screen shows up.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Allow animations and async logic to complete to prevent pending timer errors
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
