/// Base class for API and Network Exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends ApiException {
  const NetworkException({
    String message = 'Unable to connect to server. Please check your internet connection.',
  }) : super(message: message, statusCode: null);
}

class TimeoutException extends ApiException {
  const TimeoutException({
    String message = 'The connection has timed out. Please try again.',
  }) : super(message: message, statusCode: 408);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'Unauthorized access. Please sign in again.',
    dynamic details,
  }) : super(message: message, statusCode: 401, details: details);
}

class NotFoundException extends ApiException {
  const NotFoundException({
    String message = "We couldn't find an account with that email. Check it or sign up.",
    dynamic details,
  }) : super(message: message, statusCode: 404, details: details);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    String message = 'Validation failed. Please review your input.',
    this.errors,
  }) : super(message: message, statusCode: 422, details: errors);
}

class ServerException extends ApiException {
  const ServerException({
    String message = 'Internal server error occurred. Please try again later.',
    int statusCode = 500,
    dynamic details,
  }) : super(message: message, statusCode: statusCode, details: details);
}
