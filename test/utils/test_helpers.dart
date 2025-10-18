import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

/// Test utilities and helper functions for form testing
/// 
/// This class follows the Single Responsibility Principle by providing
/// reusable test utilities that can be shared across different test files.
class FormTestHelpers {
  /// Creates a test app with the UserRegistrationForm widget
  static Widget createTestApp() {
    return const MaterialApp(
      home: Scaffold(
        body: UserRegistrationForm(),
      ),
    );
  }

  /// Pumps the form widget and waits for it to settle
  static Future<void> pumpForm(WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();
  }

  /// Fills the form with valid test data
  static Future<void> fillValidForm(WidgetTester tester) async {
    final nameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);

    await tester.tap(nameField);
    await tester.enterText(nameField, 'John Doe');
    
    await tester.tap(emailField);
    await tester.enterText(emailField, 'john.doe@example.com');
    
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'Password123!');
    
    await tester.tap(confirmPasswordField);
    await tester.enterText(confirmPasswordField, 'Password123!');
    
    await tester.pumpAndSettle();
  }

  /// Fills the form with invalid test data
  static Future<void> fillInvalidForm(WidgetTester tester) async {
    final nameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).at(2);
    final confirmPasswordField = find.byType(TextFormField).at(3);

    await tester.tap(nameField);
    await tester.enterText(nameField, 'A'); // Too short
    
    await tester.tap(emailField);
    await tester.enterText(emailField, 'invalid-email'); // Invalid format
    
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'weak'); // Too weak
    
    await tester.tap(confirmPasswordField);
    await tester.enterText(confirmPasswordField, 'different'); // Mismatch
    
    await tester.pumpAndSettle();
  }

  /// Submits the form and waits for completion
  static Future<void> submitForm(WidgetTester tester) async {
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  /// Finds a specific form field by its label
  static Finder findFieldByLabel(String label) {
    return find.ancestor(
      of: find.text(label),
      matching: find.byType(TextFormField),
    );
  }

  /// Enters text into a specific field by label
  static Future<void> enterTextInField(WidgetTester tester, String label, String text) async {
    final field = findFieldByLabel(label);
    await tester.tap(field);
    await tester.enterText(field, text);
    await tester.pumpAndSettle();
  }

  /// Verifies that a validation error message is displayed
  static void expectValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }

  /// Verifies that a validation error message is not displayed
  static void expectNoValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsNothing);
  }

  /// Verifies that the form is in loading state
  static void expectLoadingState() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Register'), findsNothing);
  }

  /// Verifies that the form is not in loading state
  static void expectNotLoadingState() {
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Register'), findsOneWidget);
  }

  /// Verifies that a success message is displayed
  static void expectSuccessMessage() {
    expect(find.text('Registration successful!'), findsOneWidget);
  }

  /// Verifies that a success message is not displayed
  static void expectNoSuccessMessage() {
    expect(find.text('Registration successful!'), findsNothing);
  }

  /// Verifies that a general error message is displayed
  static void expectGeneralErrorMessage() {
    expect(find.text('Please fix the errors above before submitting'), findsOneWidget);
  }

  /// Verifies that a general error message is not displayed
  static void expectNoGeneralErrorMessage() {
    expect(find.text('Please fix the errors above before submitting'), findsNothing);
  }
}

/// Test data constants for consistent testing
class TestData {
  // Valid test data
  static const String validName = 'John Doe';
  static const String validEmail = 'john.doe@example.com';
  static const String validPassword = 'Password123!';
  static const String validConfirmPassword = 'Password123!';

  // Invalid test data
  static const String invalidName = 'A'; // Too short
  static const String invalidEmail = 'invalid-email';
  static const String invalidPassword = 'weak';
  static const String invalidConfirmPassword = 'different';

  // Edge case test data
  static const String emptyString = '';
  static const String longName = 'This is a very long name that exceeds normal expectations';
  static const String specialCharName = 'José María O\'Connor-Smith';
  static const String unicodeName = '李小明'; // Chinese characters
}

/// Validation error messages for consistent testing
class ValidationMessages {
  static const String nameRequired = 'Please enter your full name';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Please enter a password';
  static const String passwordWeak = 'Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsMismatch = 'Passwords do not match';
  static const String generalError = 'Please fix the errors above before submitting';
  static const String successMessage = 'Registration successful!';
}

/// Test scenarios for comprehensive testing
class TestScenarios {
  /// Tests all validation error messages
  static Future<void> testAllValidationErrors(WidgetTester tester) async {
    await FormTestHelpers.pumpForm(tester);
    await FormTestHelpers.submitForm(tester);
    
    FormTestHelpers.expectValidationError(ValidationMessages.nameRequired);
    FormTestHelpers.expectValidationError(ValidationMessages.emailRequired);
    FormTestHelpers.expectValidationError(ValidationMessages.passwordRequired);
    FormTestHelpers.expectValidationError(ValidationMessages.confirmPasswordRequired);
    FormTestHelpers.expectGeneralErrorMessage();
  }

  /// Tests successful form submission
  static Future<void> testSuccessfulSubmission(WidgetTester tester) async {
    await FormTestHelpers.pumpForm(tester);
    await FormTestHelpers.fillValidForm(tester);
    await FormTestHelpers.submitForm(tester);
    
    FormTestHelpers.expectSuccessMessage();
    FormTestHelpers.expectNotLoadingState();
  }

  /// Tests form field interactions
  static Future<void> testFieldInteractions(WidgetTester tester) async {
    await FormTestHelpers.pumpForm(tester);
    
    // Test name field
    await FormTestHelpers.enterTextInField(tester, 'Full Name', TestData.validName);
    FormTestHelpers.expectNoValidationError(ValidationMessages.nameRequired);
    
    // Test email field
    await FormTestHelpers.enterTextInField(tester, 'Email', TestData.validEmail);
    FormTestHelpers.expectNoValidationError(ValidationMessages.emailRequired);
    
    // Test password field
    await FormTestHelpers.enterTextInField(tester, 'Password', TestData.validPassword);
    FormTestHelpers.expectNoValidationError(ValidationMessages.passwordRequired);
    
    // Test confirm password field
    await FormTestHelpers.enterTextInField(tester, 'Confirm Password', TestData.validConfirmPassword);
    FormTestHelpers.expectNoValidationError(ValidationMessages.confirmPasswordRequired);
  }
}
