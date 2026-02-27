class AppConstants {
  // App Info
  static const String appName = 'Smart Wheel';
  static const String appVersion = '1.0.0';

  // API Endpoints (placeholder)
  static const String baseUrl = 'https://api.smartwheel.com';

  // Pagination
  static const int pageSize = 20;

  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 5000);
  static const Duration cardAnimationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;

  // Map Settings
  static const double defaultZoomLevel = 15.0;
  static const double initialLatitude = 51.5074;
  static const double initialLongitude = -0.1278;

  // Location Settings
  static const int locationRefreshIntervalSeconds = 10;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
}

class AppDimensions {
  // Padding & Margin
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Button Sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;

  // Card Sizes
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 12.0;
}
