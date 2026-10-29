/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'MindEase';
  static const String appTagline = 'by Oligal';
  static const String welcomeDescription =
      "Learn about your mental health, notice what you're feeling, and build skills to support yourself and the people around you.";

  // Shared Preferences / Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserEmail = 'user_email';
  static const String keyIsFirstTime = 'is_first_time';

  // Demo / Mock defaults from design
  static const String mockUserEmail = 'ramcy@hyperiontech.com.au';

  // Assets
  static const String logoImage = 'assets/images/logo.png';
  static const String whiteLogoImage = 'assets/images/whiteLogo.png';

}
