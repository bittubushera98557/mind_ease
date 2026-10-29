/// Generic API response wrapper
class ApiResponse<T> {
  final bool isSuccess;
  final int statusCode;
  final String? message;
  final T? data;
  final dynamic error;

  const ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.success({
    required int statusCode,
    T? data,
    String? message,
  }) {
    return ApiResponse<T>(
      isSuccess: true,
      statusCode: statusCode,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error({
    required int statusCode,
    required String message,
    dynamic error,
  }) {
    return ApiResponse<T>(
      isSuccess: false,
      statusCode: statusCode,
      message: message,
      error: error,
    );
  }
}
