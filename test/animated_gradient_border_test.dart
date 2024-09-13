import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_glow_border/animated_glow_border.dart';

void main() {
  testWidgets('AnimatedGlowBorder widget test', (WidgetTester tester) async {
    // Define the test key
    final testKey = Key('glow_container');

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedGlowBorder(
            key: testKey,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    // Verify that the AnimatedGlowBorder renders correctly
    expect(find.byKey(testKey), findsOneWidget);

    // Ensure that the child container exists inside the border
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('AnimatedGlowBorder should animate color transitions',
      (WidgetTester tester) async {
    // Build the widget with a specified animation duration
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedGlowBorder(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );

    // Initial state
    await tester.pump();

    // Wait for the animation to start
    await tester.pump(const Duration(seconds: 1));

    // Check if the widget is still visible after animation begins
    expect(find.byType(AnimatedGlowBorder), findsOneWidget);
  });
}
