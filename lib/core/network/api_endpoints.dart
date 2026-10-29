/// API Endpoint paths
class ApiEndpoints {
  ApiEndpoints._();

  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-code';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';
}
