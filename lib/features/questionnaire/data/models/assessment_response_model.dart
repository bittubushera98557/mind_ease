/// Model representing the user's assessment response from /me/assessment
class AssessmentResponseModel {
  final Map<String, dynamic> answers;
  final int step;
  final String? completedAt;
  final bool nextStepsSeen;
  final String? questionnaireVersion;
  final ApiErrorModel? error;

  const AssessmentResponseModel({
    this.answers = const {},
    this.step = 0,
    this.completedAt,
    this.nextStepsSeen = false,
    this.questionnaireVersion,
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

    Map<String, dynamic> parsedAnswers = {};
    if (json['answers'] is Map<String, dynamic>) {
      parsedAnswers = Map<String, dynamic>.from(json['answers'] as Map);
    }

    return AssessmentResponseModel(
      answers: parsedAnswers,
      step: _parseInt(json['step']),
      completedAt: json['completedAt']?.toString(),
      nextStepsSeen: json['nextStepsSeen'] == true,
      questionnaireVersion: json['questionnaireVersion']?.toString(),
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
      'answers': answers,
      'step': step,
      'completedAt': completedAt,
      'nextStepsSeen': nextStepsSeen,
      'questionnaireVersion': questionnaireVersion,
    };
  }

  AssessmentResponseModel copyWith({
    Map<String, dynamic>? answers,
    int? step,
    String? completedAt,
    bool? nextStepsSeen,
    String? questionnaireVersion,
    ApiErrorModel? error,
  }) {
    return AssessmentResponseModel(
      answers: answers ?? this.answers,
      step: step ?? this.step,
      completedAt: completedAt ?? this.completedAt,
      nextStepsSeen: nextStepsSeen ?? this.nextStepsSeen,
      questionnaireVersion: questionnaireVersion ?? this.questionnaireVersion,
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
