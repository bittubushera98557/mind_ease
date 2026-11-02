/// Model representing the response from /questionnaires/onboarding API
class OnboardingQuestionnaireModel {
  final String version;
  final String? note;
  final List<QuestionnaireQuestionModel> questions;
  final ApiErrorModel? error;

  const OnboardingQuestionnaireModel({
    this.version = '',
    this.note,
    this.questions = const [],
    this.error,
  });

  /// Returns true if the API call succeeded without error
  bool get isSuccess => error == null;

  factory OnboardingQuestionnaireModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return OnboardingQuestionnaireModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    final rawQuestions = json['questions'];
    List<QuestionnaireQuestionModel> questionsList = [];

    if (rawQuestions is List) {
      questionsList = rawQuestions
          .whereType<Map<String, dynamic>>()
          .map((item) => QuestionnaireQuestionModel.fromJson(item))
          .toList();
    }

    return OnboardingQuestionnaireModel(
      version: json['version']?.toString() ?? '',
      note: json['note']?.toString(),
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {
        'error': error!.toJson(),
      };
    }
    return {
      'version': version,
      if (note != null) 'note': note,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  OnboardingQuestionnaireModel copyWith({
    String? version,
    String? note,
    List<QuestionnaireQuestionModel>? questions,
    ApiErrorModel? error,
  }) {
    return OnboardingQuestionnaireModel(
      version: version ?? this.version,
      note: note ?? this.note,
      questions: questions ?? this.questions,
      error: error ?? this.error,
    );
  }
}

/// Model representing a question in the onboarding questionnaire
class QuestionnaireQuestionModel {
  final String id;
  final String type;
  final String q;
  final List<QuestionnaireOptionModel> options;
  final String? exclusive;

  const QuestionnaireQuestionModel({
    this.id = '',
    this.type = '',
    this.q = '',
    this.options = const [],
    this.exclusive,
  });

  factory QuestionnaireQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<QuestionnaireOptionModel> optionsList = [];

    if (rawOptions is List) {
      optionsList = rawOptions
          .whereType<Map<String, dynamic>>()
          .map((item) => QuestionnaireOptionModel.fromJson(item))
          .toList();
    }

    return QuestionnaireQuestionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      q: json['q']?.toString() ?? '',
      options: optionsList,
      exclusive: json['exclusive']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'q': q,
      'options': options.map((o) => o.toJson()).toList(),
      if (exclusive != null) 'exclusive': exclusive,
    };
  }
}

/// Model representing an option in a questionnaire question
class QuestionnaireOptionModel {
  final String v;
  final String label;

  const QuestionnaireOptionModel({
    this.v = '',
    this.label = '',
  });

  factory QuestionnaireOptionModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireOptionModel(
      v: json['v']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'v': v,
      'label': label,
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
