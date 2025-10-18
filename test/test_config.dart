/// Test configuration and constants
/// 
/// This file contains configuration settings and constants used across
/// all test files to ensure consistency and maintainability.
class TestConfig {
  /// Default timeout for async operations in tests
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  /// Timeout for form submission simulation
  static const Duration formSubmissionTimeout = Duration(seconds: 3);
  
  /// Timeout for widget settling
  static const Duration widgetSettleTimeout = Duration(milliseconds: 100);
  
  /// Enable verbose test output
  static const bool verboseOutput = true;
  
  /// Test data directory path
  static const String testDataPath = 'test/data/';
  
  /// Mock API response delay
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
