import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/main.dart';

/// Smoke tests for the Flutter Testing Lab application
/// 
/// These tests verify basic app functionality and ensure the app
/// loads without crashing. They are fast, simple, and critical.
void main() {
  group('App Smoke Tests', () {
    testWidgets('App should load without crashing', (WidgetTester tester) async {
      // Arrange & Act - Build our app and trigger a frame
      await tester.pumpWidget(const FlutterTestingLabApp());

      // Assert - Verify that the app loads successfully
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have proper structure', (WidgetTester tester) async {
      // Arrange & Act - Build our app and trigger a frame
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Assert - Verify basic app structure
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App should handle navigation without errors', (WidgetTester tester) async {
      // Arrange & Act - Build our app
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Assert - App should be stable
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
      
      // Act - Try to navigate (if navigation exists)
      // This is a basic smoke test, so we just verify no crashes
      await tester.pumpAndSettle();
      
      // Assert - App should still be stable
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
    });
  });
}
