/// Dashboard response model representing the panel dashboard metrics
class DashboardResponseModel {
  final int upcoming;
  final int next7Days;
  final int completedLast30Days;
  final int cancelledLast30Days;
  final int activeTherapists;
  final ApiErrorModel? error;

  const DashboardResponseModel({
    this.upcoming = 0,
    this.next7Days = 0,
    this.completedLast30Days = 0,
    this.cancelledLast30Days = 0,
    this.activeTherapists = 0,
    this.error,
  });

  bool get isSuccess => error == null;

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return DashboardResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    return DashboardResponseModel(
      upcoming: _parseInt(json['upcoming']),
      next7Days: _parseInt(json['next7Days']),
      completedLast30Days: _parseInt(json['completedLast30Days']),
      cancelledLast30Days: _parseInt(json['cancelledLast30Days']),
      activeTherapists: _parseInt(json['activeTherapists']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return {
      'upcoming': upcoming,
      'next7Days': next7Days,
      'completedLast30Days': completedLast30Days,
      'cancelledLast30Days': cancelledLast30Days,
      'activeTherapists': activeTherapists,
    };
  }

  DashboardResponseModel copyWith({
    int? upcoming,
    int? next7Days,
    int? completedLast30Days,
    int? cancelledLast30Days,
    int? activeTherapists,
    ApiErrorModel? error,
  }) {
    return DashboardResponseModel(
      upcoming: upcoming ?? this.upcoming,
      next7Days: next7Days ?? this.next7Days,
      completedLast30Days: completedLast30Days ?? this.completedLast30Days,
      cancelledLast30Days: cancelledLast30Days ?? this.cancelledLast30Days,
      activeTherapists: activeTherapists ?? this.activeTherapists,
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
