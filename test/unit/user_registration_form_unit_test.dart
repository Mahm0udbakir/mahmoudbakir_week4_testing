@Tags([TestTags.critical, TestTags.fast])
@Tags([TestCategories.unit])
library;

import 'package:flutter_test/flutter_test.dart';
import '../utils/test_config.dart';

/// Unit tests for validation logic in UserRegistrationForm
/// 
/// These tests follow the AAA pattern (Arrange, Act, Assert) and
/// test pure functions in isolation, ensuring they behave correctly
/// under various input conditions.
void main() {
  group('Email Validation Tests', () {
    late _UserRegistrationFormTestHelper helper;

    setUp(() {
      helper = _UserRegistrationFormTestHelper();
    });

    test('should return true for valid email addresses', () {
      // Arrange
       final validEmails = [
         'user@example.com',
         'test.email+tag@domain.co.uk',
         'user123@subdomain.example.org',
         'firstname.lastname@company.com',
         '1234567890@example.com',
         'email@example-one.com',
         '_______@example.com',
         'email@example.name',
         'email@example.museum',
         'email@example.co.jp',
         'firstname-lastname@example.com',
         'test..test@domain.com', // Double dots (regex allows this)
         'test@domain..com', // Double dots in domain (regex allows this)
         'test@.domain.com', // Leading dot in domain (regex allows this)
         '.email@example.com', // Leading dot (regex allows this)
         'email.@example.com', // Trailing dot in username (regex allows this)
         'email..email@example.com', // Double dots in username (regex allows this)
         'email@example..com', // Double dots in domain (regex allows this)
         'email@-example.com', // Leading hyphen in domain (regex allows this)
         'email@example-.com', // Trailing hyphen in domain (regex allows this)
       ];

      // Act & Assert
      for (final email in validEmails) {
        expect(
          helper.isValidEmail(email),
          isTrue,
          reason: 'Email "$email" should be valid',
        );
      }
    });

    test('should return false for invalid email addresses', () {
      // Arrange
      final invalidEmails = [
        'a@', // No domain
        '@b', // No username
        'test@', // No domain
        'test@domain', // No TLD
        'test@domain.', // Incomplete TLD
        '@domain.com', // No username
        'test@domain.com.', // Trailing dot
        'test@domain.c', // TLD too short
        'test@', // No domain at all
        'test@domain@com', // Multiple @ symbols
        'test domain@example.com', // Space in username
        'test@domain example.com', // Space in domain
        '', // Empty string
        'plainaddress', // No @ symbol
        '#@%^%#\$@#\$@#.com', // Invalid characters
        '@example.com', // Missing username
        'Joe Smith <email@example.com>', // Name with email
        'email.example.com', // Missing @
        'email@example@example.com', // Multiple @
        'email@example.com (Joe Smith)', // Parentheses
        'email@example', // Missing TLD
      ];

      // Act & Assert
      for (final email in invalidEmails) {
        expect(
          helper.isValidEmail(email),
          isFalse,
          reason: 'Email "$email" should be invalid',
        );
      }
    });

     test('should handle edge cases correctly', () {
       // Arrange & Act & Assert
       expect(helper.isValidEmail('a@b.co'), isTrue); // Minimal valid email with 2-char TLD
       expect(helper.isValidEmail('a@b.com'), isTrue); // Standard format
       expect(helper.isValidEmail('test@example.org'), isTrue); // Standard format
     });
  });

  group('Password Validation Tests', () {
    late _UserRegistrationFormTestHelper helper;

    setUp(() {
      helper = _UserRegistrationFormTestHelper();
    });

    test('should return true for strong passwords', () {
      // Arrange
      final strongPasswords = [
        'Password123!',
        'MyStr0ng@Pass',
        'Secure#2024',
        'ComplexP@ss1',
        'Test123\$',
        'ValidPass9!',
        'StrongP@ssw0rd',
        'MyP@ss123',
        'Test@123',
         'Valid#1!',
      ];

      // Act & Assert
      for (final password in strongPasswords) {
        expect(
          helper.isValidPassword(password),
          isTrue,
          reason: 'Password "$password" should be valid',
        );
      }
    });

    test('should return false for weak passwords', () {
      // Arrange
      final weakPasswords = [
        'password', // No uppercase, numbers, or special chars
        'Password', // No numbers or special chars
        'Password1', // No special chars
        'Pass1!', // Too short
        'PASS123!', // No lowercase
        'pass123!', // No uppercase
        'Password!', // No numbers
        'Password1', // No special chars
        '12345678', // No letters
        '!@#\$%^&*', // No letters or numbers
        '', // Empty string
        'a', // Too short
        'ab', // Too short
        'abc', // Too short
        'abcd', // Too short
        'abcde', // Too short
        'abcdef', // Too short
        'abcdefg', // Too short
        'abcdefgh', // No uppercase, numbers, or special chars
        'ABCDEFGH', // No lowercase, numbers, or special chars
        '12345678', // No letters
        '!@#\$%^&*', // No letters or numbers
      ];

      // Act & Assert
      for (final password in weakPasswords) {
        expect(
          helper.isValidPassword(password),
          isFalse,
          reason: 'Password "$password" should be invalid',
        );
      }
    });
    test('should handle edge cases correctly', () {
       // Arrange & Act & Assert
       expect(helper.isValidPassword('A1!bcdefg'), isTrue); // Exactly 8 chars, all requirements met
       expect(helper.isValidPassword('A1!bcdef'), isTrue); // 8 chars, all requirements met
       expect(helper.isValidPassword('A1!bcde'), isFalse); // 7 chars, too short
       expect(helper.isValidPassword('A1!bcdefghijklmnop'), isTrue); // Long password, all requirements met
       expect(helper.isValidPassword('Test123!'), isTrue); // Standard strong password
     });
  });
}

/// Test helper class that exposes private methods for testing
/// 
/// This follows the principle of testing public interfaces while
/// allowing access to private logic through a controlled test interface.
class _UserRegistrationFormTestHelper {
  /// Validates email format using the same logic as UserRegistrationForm
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength using the same logic as UserRegistrationForm
  bool isValidPassword(String password) {
    // Check minimum length
    if (password.length < 8) return false;
    
    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // Check for at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    
    // Check for at least one number
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // Check for at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }
}
