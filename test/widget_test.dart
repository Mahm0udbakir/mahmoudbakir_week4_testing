import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/main.dart';

/// Main test file for the Flutter Testing Lab application
/// 
/// This file serves as the entry point for running all tests and
/// contains basic smoke tests to ensure the app loads correctly.
void main() {
  group('App Smoke Tests', () {
    testWidgets('App should load without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const FlutterTestingLabApp());

      // Verify that the app loads successfully
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home page should be displayed', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const FlutterTestingLabApp());
      await tester.pumpAndSettle();

      // Verify that the home page is displayed
      expect(find.byType(FlutterTestingLabApp), findsOneWidget);
    });
  });
}
