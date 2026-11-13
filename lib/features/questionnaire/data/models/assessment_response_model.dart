/// Model representing a single focus phase inside recommendation
class FocusPhaseModel {
  final String phaseId;
  final int number;
  final String title;
  final String? color;
  final List<String> reasons;

  const FocusPhaseModel({
    this.phaseId = '',
    this.number = 1,
    this.title = '',
    this.color,
    this.reasons = const [],
  });

  factory FocusPhaseModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedReasons = [];
    if (json['reasons'] is List) {
      parsedReasons = (json['reasons'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return FocusPhaseModel(
      phaseId: json['phaseId']?.toString() ?? '',
      number: _parseInt(json['number'], defaultValue: 1),
      title: json['title']?.toString() ?? '',
      color: json['color']?.toString(),
      reasons: parsedReasons,
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 1}) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'phaseId': phaseId,
      'number': number,
      'title': title,
      if (color != null) 'color': color,
      'reasons': reasons,
    };
  }
}

/// Model representing assessment recommendation from /me/assessment
class RecommendationModel {
  final String? programId;
  final List<FocusPhaseModel> focusPhases;
  final bool showSupport;
  final bool suggestProfessional;
  final int? dailyMinutes;
  final String? learningStyle;
  final String? preferredKind;
  final List<String> focusAreas;

  const RecommendationModel({
    this.programId,
    this.focusPhases = const [],
    this.showSupport = false,
    this.suggestProfessional = false,
    this.dailyMinutes,
    this.learningStyle,
    this.preferredKind,
    this.focusAreas = const [],
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    List<FocusPhaseModel> phases = [];
    if (json['focusPhases'] is List) {
      phases = (json['focusPhases'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => FocusPhaseModel.fromJson(item))
          .toList();
    }

    List<String> areas = [];
    if (json['focusAreas'] is List) {
      areas = (json['focusAreas'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    int? parsedDailyMinutes;
    if (json['dailyMinutes'] != null) {
      if (json['dailyMinutes'] is num) {
        parsedDailyMinutes = (json['dailyMinutes'] as num).toInt();
      } else if (json['dailyMinutes'] is String) {
        parsedDailyMinutes = int.tryParse(json['dailyMinutes'] as String);
      }
    }

    return RecommendationModel(
      programId: json['programId']?.toString(),
      focusPhases: phases,
      showSupport: json['showSupport'] == true,
      suggestProfessional: json['suggestProfessional'] == true,
      dailyMinutes: parsedDailyMinutes,
      learningStyle: json['learningStyle']?.toString(),
      preferredKind: json['preferredKind']?.toString(),
      focusAreas: areas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (programId != null) 'programId': programId,
      'focusPhases': focusPhases.map((p) => p.toJson()).toList(),
      'showSupport': showSupport,
      'suggestProfessional': suggestProfessional,
      if (dailyMinutes != null) 'dailyMinutes': dailyMinutes,
      if (learningStyle != null) 'learningStyle': learningStyle,
      if (preferredKind != null) 'preferredKind': preferredKind,
      'focusAreas': focusAreas,
    };
  }
}

/// Model representing the user's assessment response from /me/assessment
class AssessmentResponseModel {
  final dynamic answers;
  final int step;
  final String? completedAt;
  final bool nextStepsSeen;
  final String? questionnaireVersion;
  final RecommendationModel? recommendation;
  final ApiErrorModel? error;

  const AssessmentResponseModel({
    this.answers,
    this.step = 0,
    this.completedAt,
    this.nextStepsSeen = false,
    this.questionnaireVersion,
    this.recommendation,
    this.error,
  });

  /// Returns true if API response was successful (no error)
  bool get isSuccess => error == null;

  factory AssessmentResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return AssessmentResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    RecommendationModel? rec;
    if (json['recommendation'] is Map<String, dynamic>) {
      rec = RecommendationModel.fromJson(
          json['recommendation'] as Map<String, dynamic>);
    }

    return AssessmentResponseModel(
      answers: json['answers'],
      step: _parseInt(json['step']),
      completedAt: json['completedAt']?.toString(),
      nextStepsSeen: json['nextStepsSeen'] == true,
      questionnaireVersion: json['questionnaireVersion']?.toString(),
      recommendation: rec,
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
      if (answers != null) 'answers': answers,
      'step': step,
      if (completedAt != null) 'completedAt': completedAt,
      'nextStepsSeen': nextStepsSeen,
      if (questionnaireVersion != null)
        'questionnaireVersion': questionnaireVersion,
      if (recommendation != null) 'recommendation': recommendation!.toJson(),
    };
  }

  AssessmentResponseModel copyWith({
    dynamic answers,
    int? step,
    String? completedAt,
    bool? nextStepsSeen,
    String? questionnaireVersion,
    RecommendationModel? recommendation,
    ApiErrorModel? error,
  }) {
    return AssessmentResponseModel(
      answers: answers ?? this.answers,
      step: step ?? this.step,
      completedAt: completedAt ?? this.completedAt,
      nextStepsSeen: nextStepsSeen ?? this.nextStepsSeen,
      questionnaireVersion: questionnaireVersion ?? this.questionnaireVersion,
      recommendation: recommendation ?? this.recommendation,
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
      if (field != null) 'field': field,
    };
  }
}
