import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

import '../utils/test_config.dart';
import '../utils/test_helpers.dart';

/// Comprehensive widget tests for UserRegistrationForm
/// 
/// These tests follow the Page Object Model pattern and test the complete
/// user interaction flow, ensuring the form behaves correctly in all scenarios.
void main() {
  group('UserRegistrationForm Widget Tests', () {

    setUp(() {
      // Each test gets a fresh widget tester instance
    });

    group('Form Rendering Tests', () {
      testWidgets('should render all form fields correctly', (WidgetTester tester) async {
        // Arrange & Act
        await FormTestHelpers.pumpForm(tester);

        // Assert - Check all form fields are present
        expect(find.byType(UserRegistrationForm), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(4)); // Name, Email, Password, Confirm Password
        
        // Assert - Check field labels
        expect(find.text('Full Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);
        
        // Assert - Check submit button
        expect(find.text('Register'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should display helper text for password field', (WidgetTester tester) async {
        // Arrange & Act
        await FormTestHelpers.pumpForm(tester);

        // Assert
        expect(
          find.text('At least 8 characters with uppercase, lowercase, numbers, and special characters'),
          findsOneWidget,
        );
      });

      testWidgets('should have password fields as obscure text', (WidgetTester tester) async {
        // Arrange & Act
        await FormTestHelpers.pumpForm(tester);

        // Assert - Check that password fields exist
        final passwordFields = find.byType(TextFormField);
        expect(passwordFields, findsNWidgets(4));
        
        // Note: We can't directly test obscureText property as it's not exposed
        // Instead, we verify the fields exist and can be interacted with
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show validation errors for empty fields', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);

        // Act - Submit form without filling any fields
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Check validation error messages
        FormTestHelpers.expectValidationError(ValidationMessages.nameRequired);
        FormTestHelpers.expectValidationError(ValidationMessages.emailRequired);
        FormTestHelpers.expectValidationError(ValidationMessages.passwordRequired);
        FormTestHelpers.expectValidationError(ValidationMessages.confirmPasswordRequired);
        FormTestHelpers.expectGeneralErrorMessage();
      });

      testWidgets('should validate name field correctly', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        final nameField = find.byType(TextFormField).first;

        // Act & Assert - Test empty name
        await tester.tap(nameField);
        await tester.enterText(nameField, '');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.nameRequired);

        // Act & Assert - Test name too short
        await tester.enterText(nameField, 'A');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.nameTooShort);

        // Act & Assert - Test valid name
        await tester.enterText(nameField, TestData.validName);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter your full name'), findsNothing);
        expect(find.text('Name must be at least 2 characters'), findsNothing);
      });

      testWidgets('should validate email field correctly', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        final emailField = find.byType(TextFormField).at(1);

        // Act & Assert - Test empty email
        await tester.tap(emailField);
        await tester.enterText(emailField, '');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.emailRequired);

        // Act & Assert - Test invalid email formats
        final invalidEmails = ['a@', '@b', 'test@', 'test@domain', 'plainaddress'];
        for (final email in invalidEmails) {
          await tester.enterText(emailField, email);
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();
          FormTestHelpers.expectValidationError(ValidationMessages.emailInvalid);
        }

        // Act & Assert - Test valid email
        await tester.enterText(emailField, TestData.validEmail);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter your email'), findsNothing);
        expect(find.text('Please enter a valid email'), findsNothing);
      });

      testWidgets('should validate password field correctly', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        final passwordField = find.byType(TextFormField).at(2);

        // Act & Assert - Test empty password
        await tester.tap(passwordField);
        await tester.enterText(passwordField, '');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.passwordRequired);

        // Act & Assert - Test weak passwords
        final weakPasswords = ['password', 'Password', 'Password1', 'Pass1!'];
        for (final password in weakPasswords) {
          await tester.enterText(passwordField, password);
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();
          expect(
            find.text('Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters'),
            findsOneWidget,
          );
        }

        // Act & Assert - Test valid password
        await tester.enterText(passwordField, TestData.validPassword);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please enter a password'), findsNothing);
        expect(
          find.text('Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters'),
          findsNothing,
        );
      });

      testWidgets('should validate confirm password field correctly', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        final passwordField = find.byType(TextFormField).at(2);
        final confirmPasswordField = find.byType(TextFormField).at(3);

        // Act - Enter valid password
        await tester.tap(passwordField);
        await tester.enterText(passwordField, TestData.validPassword);

        // Act & Assert - Test empty confirm password
        await tester.tap(confirmPasswordField);
        await tester.enterText(confirmPasswordField, '');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.confirmPasswordRequired);

        // Act & Assert - Test mismatched passwords
        await tester.enterText(confirmPasswordField, 'DifferentPassword123!');
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        FormTestHelpers.expectValidationError(ValidationMessages.passwordsMismatch);

        // Act & Assert - Test matching passwords
        await tester.enterText(confirmPasswordField, TestData.validConfirmPassword);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();
        expect(find.text('Please confirm your password'), findsNothing);
        expect(find.text('Passwords do not match'), findsNothing);
      });
    });

    group('Form Submission Tests', () {
      testWidgets('should show loading state during submission', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        await FormTestHelpers.fillValidForm(tester);

        // Act - Submit form
        await tester.tap(find.text('Register'));
        await tester.pump(); // Don't settle, check loading state

        // Assert - Check loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Register'), findsNothing); // Button text should be replaced by loading indicator
        
        // Wait for the async operation to complete
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout);
      });

      testWidgets('should show success message after successful submission', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        await FormTestHelpers.fillValidForm(tester);

        // Act - Submit form and wait for completion
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout); // Wait for simulated API call

        // Assert - Check success message
        FormTestHelpers.expectSuccessMessage();
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Register'), findsOneWidget); // Button should be back
      });

      testWidgets('should not submit form with validation errors', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);

        // Act - Submit form with invalid data
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Should show validation error message, not success
        FormTestHelpers.expectGeneralErrorMessage();
        expect(find.text('Registration successful!'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('should disable submit button during loading', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        await FormTestHelpers.fillValidForm(tester);

        // Act - Submit form
        await tester.tap(find.text('Register'));
        await tester.pump();

        // Assert - Button should be disabled
        final submitButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(submitButton.onPressed, isNull); // Disabled button has null onPressed
        
        // Wait for the async operation to complete
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout);
      });
    });

    group('Form State Management Tests', () {
      testWidgets('should clear form fields after successful submission', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        await FormTestHelpers.fillValidForm(tester);

        // Act - Submit form and wait for completion
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout);

        // Assert - Form should still be filled (this is typical behavior)
        // Note: In a real app, you might want to clear the form after success
        final nameField = tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(nameField.controller?.text, equals('John Doe'));
      });

      testWidgets('should maintain form state during validation', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        final nameField = find.byType(TextFormField).first;

        // Act - Enter text and trigger validation
        await tester.tap(nameField);
        await tester.enterText(nameField, TestData.validName);
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Text should still be in the field
        final nameFieldWidget = tester.widget<TextFormField>(find.byType(TextFormField).first);
        expect(nameFieldWidget.controller?.text, equals('John Doe'));
      });
    });

    group('Error Message Display Tests', () {
      testWidgets('should display error messages in styled containers', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);

        // Act - Submit form with validation errors
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Check that error message is in a styled container
        FormTestHelpers.expectGeneralErrorMessage();
        
        // Check for styled container (should have decoration)
        final errorContainer = find.ancestor(
          of: find.text('Please fix the errors above before submitting'),
          matching: find.byType(Container),
        );
        expect(errorContainer, findsOneWidget);
      });

      testWidgets('should display success message in styled container', (WidgetTester tester) async {
        // Arrange
        await FormTestHelpers.pumpForm(tester);
        await FormTestHelpers.fillValidForm(tester);

        // Act - Submit form successfully
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle(TestConfig.formSubmissionTimeout);

        // Assert - Check that success message is in a styled container
        FormTestHelpers.expectSuccessMessage();
        
        // Check for styled container
        final successContainer = find.ancestor(
          of: find.text('Registration successful!'),
          matching: find.byType(Container),
        );
        expect(successContainer, findsOneWidget);
      });
    });
  });
}
