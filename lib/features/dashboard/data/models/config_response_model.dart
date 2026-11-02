/// Model representing the response from /config endpoint
class ConfigResponseModel {
  final int passThresholdPercent;
  final int pointsPerPhase;
  final int videoCompletePercent;
  final PhaseRequirementsModel? phaseRequirements;
  final bool previewVideosWithoutMedia;
  final ApiErrorModel? error;

  const ConfigResponseModel({
    this.passThresholdPercent = 80,
    this.pointsPerPhase = 100,
    this.videoCompletePercent = 90,
    this.phaseRequirements,
    this.previewVideosWithoutMedia = true,
    this.error,
  });

  /// Returns true if API response was successful
  bool get isSuccess => error == null;

  factory ConfigResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return ConfigResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    return ConfigResponseModel(
      passThresholdPercent:
          _parseInt(json['passThresholdPercent'], defaultValue: 80),
      pointsPerPhase: _parseInt(json['pointsPerPhase'], defaultValue: 100),
      videoCompletePercent:
          _parseInt(json['videoCompletePercent'], defaultValue: 90),
      phaseRequirements: json['phaseRequirements'] is Map<String, dynamic>
          ? PhaseRequirementsModel.fromJson(
              json['phaseRequirements'] as Map<String, dynamic>)
          : null,
      previewVideosWithoutMedia: json['previewVideosWithoutMedia'] != false,
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return {
      'passThresholdPercent': passThresholdPercent,
      'pointsPerPhase': pointsPerPhase,
      'videoCompletePercent': videoCompletePercent,
      if (phaseRequirements != null)
        'phaseRequirements': phaseRequirements!.toJson(),
      'previewVideosWithoutMedia': previewVideosWithoutMedia,
    };
  }

  ConfigResponseModel copyWith({
    int? passThresholdPercent,
    int? pointsPerPhase,
    int? videoCompletePercent,
    PhaseRequirementsModel? phaseRequirements,
    bool? previewVideosWithoutMedia,
    ApiErrorModel? error,
  }) {
    return ConfigResponseModel(
      passThresholdPercent: passThresholdPercent ?? this.passThresholdPercent,
      pointsPerPhase: pointsPerPhase ?? this.pointsPerPhase,
      videoCompletePercent: videoCompletePercent ?? this.videoCompletePercent,
      phaseRequirements: phaseRequirements ?? this.phaseRequirements,
      previewVideosWithoutMedia:
          previewVideosWithoutMedia ?? this.previewVideosWithoutMedia,
      error: error ?? this.error,
    );
  }
}

/// Model representing phase requirement flags in config
class PhaseRequirementsModel {
  final bool lessons;
  final bool videos;
  final bool activity;
  final bool quiz;

  const PhaseRequirementsModel({
    this.lessons = true,
    this.videos = true,
    this.activity = true,
    this.quiz = true,
  });

  factory PhaseRequirementsModel.fromJson(Map<String, dynamic> json) {
    return PhaseRequirementsModel(
      lessons: json['lessons'] == true,
      videos: json['videos'] == true,
      activity: json['activity'] == true,
      quiz: json['quiz'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessons': lessons,
      'videos': videos,
      'activity': activity,
      'quiz': quiz,
    };
  }

  PhaseRequirementsModel copyWith({
    bool? lessons,
    bool? videos,
    bool? activity,
    bool? quiz,
  }) {
    return PhaseRequirementsModel(
      lessons: lessons ?? this.lessons,
      videos: videos ?? this.videos,
      activity: activity ?? this.activity,
      quiz: quiz ?? this.quiz,
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
