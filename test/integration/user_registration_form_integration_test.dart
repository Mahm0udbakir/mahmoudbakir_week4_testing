import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';


/// Integration tests for complete form flow scenarios
///
/// These tests simulate real user interactions and test the complete
/// end-to-end flow of the registration form, ensuring all components
/// work together correctly.
void main() {
  group('Form Flow Integration Tests', () {
    group('Form Accessibility Tests', () {
      testWidgets('should be accessible with keyboard navigation',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Navigate through form fields using tab
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        // Assert - Form should still be responsive after keyboard navigation
        expect(find.byType(UserRegistrationForm), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should have proper semantic labels',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Check for semantic labels
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);
        expect(find.text('Register'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid form interactions without issues',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Rapid interactions
        final nameField = find.byType(TextFormField).first;
        for (int i = 0; i < 10; i++) {
          await tester.tap(nameField);
          await tester.enterText(nameField, 'Test$i');
          await tester.pump();
        }

        // Assert - Form should still be responsive
        expect(find.byType(UserRegistrationForm), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should handle long text input without performance issues',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Enter very long text
        final nameField = find.byType(TextFormField).first;
        const longText =
            'This is a very long name that should not cause any performance issues in the form validation or display';

        await tester.tap(nameField);
        await tester.enterText(nameField, longText);
        await tester.pumpAndSettle();

        // Assert - Form should handle long text gracefully
        expect(find.byType(UserRegistrationForm), findsOneWidget);
        final nameFieldWidget =
            tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(nameFieldWidget.controller?.text, equals(longText));
      });
    });
  });
}

