import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

import '../utils/test_config.dart';
import '../utils/test_helpers.dart';

/// Integration tests for complete form flow scenarios
///
/// These tests simulate real user interactions and test the complete
/// end-to-end flow of the registration form, ensuring all components
/// work together correctly.
void main() {
  group('Form Flow Integration Tests', () {
    group('Complete Registration Flow', () {
      testWidgets('should complete full registration flow successfully',
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

        // Act - Fill out the complete form
        await FormTestHelpers.fillValidForm(tester);

        // Assert - Verify success
        FormTestHelpers.expectSuccessMessage();
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should handle form validation errors in sequence',
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

        // Act & Assert - Test step-by-step validation
        await FormTestHelpers.testStepByStepValidation(tester);
      });

      testWidgets('should handle multiple submission attempts',
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

        // Act - Fill form and submit multiple times
        await FormTestHelpers.fillValidForm(tester);
        FormTestHelpers.expectSuccessMessage();

        // Act - Submit again
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout);

        // Assert - Should show success again
        FormTestHelpers.expectSuccessMessage();
      });
    });

    group('Error Recovery Flow', () {
      testWidgets('should allow user to fix errors and resubmit',
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

        // Act - Submit with invalid data
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectGeneralErrorMessage();

        // Act - Fix errors and resubmit
        await FormTestHelpers.fillValidForm(tester);

        // Assert - Should succeed
        FormTestHelpers.expectSuccessMessage();
      });

      testWidgets('should clear validation errors when fields are corrected',
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

        // Act - Submit with invalid email
        final emailField = find.byType(TextFormField).at(1);
        await tester.tap(emailField);
        await tester.enterText(emailField, TestData.invalidEmail);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.emailInvalid);

        // Act - Fix email
        await tester.enterText(emailField, TestData.validEmail);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Email error should be gone, but other errors remain
        expect(find.text(ValidationMessages.emailInvalid), findsNothing);
        FormTestHelpers.expectValidationError(ValidationMessages.nameRequired);
      });
    });

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

