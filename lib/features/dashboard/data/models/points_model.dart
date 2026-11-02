/// Model representing the user's points response from /me/points
class PointsModel {
  final int total;
  final List<PointAwardModel> awards;
  final ApiErrorModel? error;

  const PointsModel({
    this.total = 0,
    this.awards = const [],
    this.error,
  });

  bool get isSuccess => error == null;

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return PointsModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    final rawAwards = json['awards'];
    List<PointAwardModel> awardsList = [];

    if (rawAwards is List) {
      awardsList = rawAwards
          .whereType<Map<String, dynamic>>()
          .map((item) => PointAwardModel.fromJson(item))
          .toList();
    }

    return PointsModel(
      total: _parseInt(json['total']),
      awards: awardsList,
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
      'total': total,
      'awards': awards.map((a) => a.toJson()).toList(),
    };
  }

  PointsModel copyWith({
    int? total,
    List<PointAwardModel>? awards,
    ApiErrorModel? error,
  }) {
    return PointsModel(
      total: total ?? this.total,
      awards: awards ?? this.awards,
      error: error ?? this.error,
    );
  }
}

/// Model representing an individual points award item
class PointAwardModel {
  final String programId;
  final String phaseId;
  final int points;
  final String awardedAt;

  const PointAwardModel({
    this.programId = '',
    this.phaseId = '',
    this.points = 0,
    this.awardedAt = '',
  });

  factory PointAwardModel.fromJson(Map<String, dynamic> json) {
    return PointAwardModel(
      programId: json['programId']?.toString() ?? '',
      phaseId: json['phaseId']?.toString() ?? '',
      points: _parseInt(json['points']),
      awardedAt: json['awardedAt']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'programId': programId,
      'phaseId': phaseId,
      'points': points,
      'awardedAt': awardedAt,
    };
  }

  PointAwardModel copyWith({
    String? programId,
    String? phaseId,
    int? points,
    String? awardedAt,
  }) {
    return PointAwardModel(
      programId: programId ?? this.programId,
      phaseId: phaseId ?? this.phaseId,
      points: points ?? this.points,
      awardedAt: awardedAt ?? this.awardedAt,
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
