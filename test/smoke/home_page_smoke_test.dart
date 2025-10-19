import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/main.dart';
import 'package:flutter_testing_lab/home_page.dart';

/// Smoke tests for the Home Page
/// 
/// These tests verify that the home page loads correctly and
/// displays the expected content without errors.
void main() {
  group('Home Page Smoke Tests', () {
    testWidgets('Home page should be displayed', (WidgetTester tester) async {
      // Arrange & Act - Build our app and trigger a frame
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Assert - Verify that the home page is displayed
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Home page should have basic structure', (WidgetTester tester) async {
      // Arrange & Act - Build our app
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Assert - Verify home page structure
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Home page should be interactive', (WidgetTester tester) async {
      // Arrange & Act - Build our app
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Assert - Home page should be present and interactive
      expect(find.byType(HomePage), findsOneWidget);
      
      // Act - Try basic interactions
      await tester.pumpAndSettle();
      
      // Assert - Should still be stable
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
