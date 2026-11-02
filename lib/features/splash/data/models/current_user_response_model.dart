import '../../../auth/data/models/user_model.dart';

/// Response model for current user (/me) endpoint
class CurrentUserResponseModel {
  final String? id;
  final String? name;
  final String? email;
  final String? createdAt;
  final ApiErrorModel? error;

  const CurrentUserResponseModel({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.error,
  });

  /// Helper getter to check if API call succeeded
  bool get isSuccess => error == null && id != null && id!.isNotEmpty;

  /// Helper method to convert payload to UserModel if needed
  UserModel? toUserModel() {
    if (!isSuccess) return null;
    return UserModel(
      id: id ?? '',
      name: name ?? '',
      email: email ?? '',
      createdAt: createdAt,
    );
  }

  factory CurrentUserResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return CurrentUserResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    return CurrentUserResponseModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return {
      'id': id,
      'name': name,
      'email': email,
      if (createdAt != null) 'createdAt': createdAt,
    };
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
