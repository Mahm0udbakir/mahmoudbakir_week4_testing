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
    group('Complete Registration Flow', () {
      testWidgets('should complete full registration flow successfully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Fill out the complete form
        await _completeRegistrationFlow(tester);

        // Assert - Verify success
        expect(find.text('Registration successful!'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should handle form validation errors in sequence', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act & Assert - Test step-by-step validation
        await _testStepByStepValidation(tester);
      });

      testWidgets('should handle multiple submission attempts', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Fill form and submit multiple times
        await _completeRegistrationFlow(tester);
        expect(find.text('Registration successful!'), findsOneWidget);

        // Act - Submit again
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Should show success again
        expect(find.text('Registration successful!'), findsOneWidget);
      });
    });

    group('Error Recovery Flow', () {
      testWidgets('should allow user to fix errors and resubmit', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Submit with invalid data
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please fix the errors above before submitting'), findsOneWidget);

        // Act - Fix errors and resubmit
        await _completeRegistrationFlow(tester);

        // Assert - Should succeed
        expect(find.text('Registration successful!'), findsOneWidget);
      });

      testWidgets('should clear validation errors when fields are corrected', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: UserRegistrationForm(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - Submit with invalid email
        final emailField = find.byType(TextFormField).at(1);
        await tester.tap(emailField);
        await tester.enterText(emailField, 'invalid-email');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a valid email'), findsOneWidget);

        // Act - Fix email
        await tester.enterText(emailField, 'valid@example.com');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Email error should be gone, but other errors remain
        expect(find.text('Please enter a valid email'), findsNothing);
        expect(find.text('Please enter your full name'), findsOneWidget);
      });
    });

    group('Form Accessibility Tests', () {
      testWidgets('should be accessible with keyboard navigation', (WidgetTester tester) async {
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

      testWidgets('should have proper semantic labels', (WidgetTester tester) async {
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
      testWidgets('should handle rapid form interactions without issues', (WidgetTester tester) async {
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

      testWidgets('should handle long text input without performance issues', (WidgetTester tester) async {
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
        const longText = 'This is a very long name that should not cause any performance issues in the form validation or display';
        
        await tester.tap(nameField);
        await tester.enterText(nameField, longText);
        await tester.pumpAndSettle();

        // Assert - Form should handle long text gracefully
        expect(find.byType(UserRegistrationForm), findsOneWidget);
        final nameFieldWidget = tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(nameFieldWidget.controller?.text, equals(longText));
      });
    });
  });
}

/// Helper function to complete the full registration flow
Future<void> _completeRegistrationFlow(WidgetTester tester) async {
  final nameField = find.byType(TextFormField).first;
  final emailField = find.byType(TextFormField).at(1);
  final passwordField = find.byType(TextFormField).at(2);
  final confirmPasswordField = find.byType(TextFormField).at(3);

  // Fill name
  await tester.tap(nameField);
  await tester.enterText(nameField, 'John Doe');
  
  // Fill email
  await tester.tap(emailField);
  await tester.enterText(emailField, 'john.doe@example.com');
  
  // Fill password
  await tester.tap(passwordField);
  await tester.enterText(passwordField, 'Password123!');
  
  // Fill confirm password
  await tester.tap(confirmPasswordField);
  await tester.enterText(confirmPasswordField, 'Password123!');
  
  // Submit form
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// Helper function to test step-by-step validation
Future<void> _testStepByStepValidation(WidgetTester tester) async {
  // Test 1: Empty form
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(find.text('Please fix the errors above before submitting'), findsOneWidget);

  // Test 2: Add name only
  final nameField = find.byType(TextFormField).first;
  await tester.tap(nameField);
  await tester.enterText(nameField, 'John Doe');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(find.text('Please enter your full name'), findsNothing);

  // Test 3: Add invalid email
  final emailField = find.byType(TextFormField).at(1);
  await tester.tap(emailField);
  await tester.enterText(emailField, 'invalid-email');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(find.text('Please enter a valid email'), findsOneWidget);

  // Test 4: Fix email
  await tester.enterText(emailField, 'john@example.com');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(find.text('Please enter a valid email'), findsNothing);

  // Test 5: Add weak password
  final passwordField = find.byType(TextFormField).at(2);
  await tester.tap(passwordField);
  await tester.enterText(passwordField, 'weak');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(
    find.text('Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters'),
    findsOneWidget,
  );

  // Test 6: Fix password
  await tester.enterText(passwordField, 'Password123!');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(
    find.text('Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters'),
    findsNothing,
  );

  // Test 7: Add mismatched confirm password
  final confirmPasswordField = find.byType(TextFormField).at(3);
  await tester.tap(confirmPasswordField);
  await tester.enterText(confirmPasswordField, 'DifferentPassword123!');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();
  expect(find.text('Passwords do not match'), findsOneWidget);

  // Test 8: Fix confirm password
  await tester.enterText(confirmPasswordField, 'Password123!');
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.text('Passwords do not match'), findsNothing);
  expect(find.text('Registration successful!'), findsOneWidget);
}
