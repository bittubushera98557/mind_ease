/// Model representing response from /auth/refresh API
class TokenRefreshResponseModel {
  final String accessToken;
  final String refreshToken;
  final ApiErrorModel? error;

  const TokenRefreshResponseModel({
    this.accessToken = '',
    this.refreshToken = '',
    this.error,
  });

  /// Returns true if token refresh request succeeded
  bool get isSuccess => error == null && accessToken.isNotEmpty;

  factory TokenRefreshResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return TokenRefreshResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    return TokenRefreshResponseModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  TokenRefreshResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    ApiErrorModel? error,
  }) {
    return TokenRefreshResponseModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      error: error ?? this.error,
    );
  }
}

/// Model representing API error response
class ApiErrorModel {
  final String code;
  final String message;
  final String? field;

  const ApiErrorModel({
    required this.code,
    required this.message,
    this.field,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      field: json['field']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'field': field,
    };
  }
}
