/// API Endpoint paths
class ApiEndpoints {
  ApiEndpoints._();

  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-code';
  static const String resetPassword = '/auth/reset-password';

/*forget password without login*/
  static const String passwordResetForget = '/auth/password-reset';

  /*profile section*/
  static const String logout = '/auth/logout';
  static const String currentUser = '/me'; // it will be hit with bearer token
  static const String deleteMyPhoto = '/me/photo'; // it will be hit with bearer token
  static const String password = '/me/password'; //  for update password from profile

/*support content */
  static const String  supportResources = '/support-resources'; //  for get support information


   static const String mePoints = '/me/points'; // it will be hit with bearer token
  static const String meAssessment = '/me/assessment'; // it will be hit with bearer token
  static const String tokenRefresh = '/auth/refresh'; // {"refreshToken": "string" }
  static const String bookings = '/me/bookings';
  static const String config = '/config';
  static const String questionnairesOnboarding = '/questionnaires/onboarding';
  static const String programs = '/programs';
  static const String programDetailWithId = '/programs/{programId}';

  // static const String dashboard = '/panel/dashboard';

  // Telehealth / Zoom Video SDK Token endpoint
  static const String telehealthToken = '/telehealth/token';
}
