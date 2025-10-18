/// Test configuration and constants
///
/// This file contains configuration settings and constants used across
/// all test files to ensure consistency and maintainability.
class TestConfig {
  /// The standard timeout for async operations in tests.
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Specifically for form submission simulation
  static const Duration formSubmissionTimeout = Duration(seconds: 3);

  /// The timeout for widget settling.
  static const Duration widgetSettleTimeout = Duration(milliseconds: 100);

  /// Controls whether tests should output detailed information during execution.
  static const bool verboseOutput = true;
  
  static const String testDataPath = 'test/data/';
  static const Duration mockApiDelay = Duration(seconds: 2);
}

/// Test categories for organizing tests
class TestCategories {
  static const String unit = 'unit';
  static const String widget = 'widget';
  static const String integration = 'integration';
  static const String smoke = 'smoke';
  static const String performance = 'performance';
  static const String accessibility = 'accessibility';
}

/// Test tags for filtering tests
class TestTags {
  static const String critical = 'critical';
  static const String regression = 'regression';
  static const String feature = 'feature';
  static const String bugfix = 'bugfix';
  static const String slow = 'slow';
  static const String fast = 'fast';
}
