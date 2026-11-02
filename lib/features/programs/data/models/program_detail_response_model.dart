/// Model representing full program detail response from /programs/{programId}
class ProgramDetailResponseModel {
  final String id;
  final String title;
  final String short;
  final String? intro;
  final List<String> learn;
  final String? disclaimer;
  final String? contentVersion;
  final int displayOrder;
  final List<ProgramPhaseModel> phases;
  final ApiErrorModel? error;

  const ProgramDetailResponseModel({
    this.id = '',
    this.title = '',
    this.short = '',
    this.intro,
    this.learn = const [],
    this.disclaimer,
    this.contentVersion,
    this.displayOrder = 0,
    this.phases = const [],
    this.error,
  });

  /// Returns true if API response was successful
  bool get isSuccess => error == null;

  factory ProgramDetailResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return ProgramDetailResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    final rawLearn = json['learn'];
    List<String> learnList = [];
    if (rawLearn is List) {
      learnList = rawLearn.map((e) => e.toString()).toList();
    }

    final rawPhases = json['phases'];
    List<ProgramPhaseModel> phasesList = [];
    if (rawPhases is List) {
      phasesList = rawPhases
          .whereType<Map<String, dynamic>>()
          .map((item) => ProgramPhaseModel.fromJson(item))
          .toList();
    }

    return ProgramDetailResponseModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      short: json['short']?.toString() ?? '',
      intro: json['intro']?.toString(),
      learn: learnList,
      disclaimer: json['disclaimer']?.toString(),
      contentVersion: json['contentVersion']?.toString(),
      displayOrder: _parseInt(json['displayOrder']),
      phases: phasesList,
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
      'id': id,
      'title': title,
      'short': short,
      if (intro != null) 'intro': intro,
      'learn': learn,
      if (disclaimer != null) 'disclaimer': disclaimer,
      if (contentVersion != null) 'contentVersion': contentVersion,
      'displayOrder': displayOrder,
      'phases': phases.map((p) => p.toJson()).toList(),
    };
  }
}

/// Model representing a phase inside a program
class ProgramPhaseModel {
  final String id;
  final int number;
  final String title;
  final String description;
  final List<String> objectives;
  final String color;
  final int? pointsAwarded;
  final List<PhaseLessonModel> lessons;
  final List<PhaseVideoModel> videos;
  final PhaseActivityModel? activity;
  final PhaseQuizModel? quiz;

  const ProgramPhaseModel({
    this.id = '',
    this.number = 0,
    this.title = '',
    this.description = '',
    this.objectives = const [],
    this.color = '',
    this.pointsAwarded,
    this.lessons = const [],
    this.videos = const [],
    this.activity,
    this.quiz,
  });

  factory ProgramPhaseModel.fromJson(Map<String, dynamic> json) {
    final rawObjectives = json['objectives'];
    List<String> objectivesList = [];
    if (rawObjectives is List) {
      objectivesList = rawObjectives.map((e) => e.toString()).toList();
    }

    final rawLessons = json['lessons'];
    List<PhaseLessonModel> lessonsList = [];
    if (rawLessons is List) {
      lessonsList = rawLessons
          .whereType<Map<String, dynamic>>()
          .map((item) => PhaseLessonModel.fromJson(item))
          .toList();
    }

    final rawVideos = json['videos'];
    List<PhaseVideoModel> videosList = [];
    if (rawVideos is List) {
      videosList = rawVideos
          .whereType<Map<String, dynamic>>()
          .map((item) => PhaseVideoModel.fromJson(item))
          .toList();
    }

    return ProgramPhaseModel(
      id: json['id']?.toString() ?? '',
      number: _parseInt(json['number']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      objectives: objectivesList,
      color: json['color']?.toString() ?? '',
      pointsAwarded: json['pointsAwarded'] != null
          ? _parseInt(json['pointsAwarded'])
          : null,
      lessons: lessonsList,
      videos: videosList,
      activity: json['activity'] is Map<String, dynamic>
          ? PhaseActivityModel.fromJson(json['activity'] as Map<String, dynamic>)
          : null,
      quiz: json['quiz'] is Map<String, dynamic>
          ? PhaseQuizModel.fromJson(json['quiz'] as Map<String, dynamic>)
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'description': description,
      'objectives': objectives,
      'color': color,
      'pointsAwarded': pointsAwarded,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'videos': videos.map((v) => v.toJson()).toList(),
      if (activity != null) 'activity': activity!.toJson(),
      if (quiz != null) 'quiz': quiz!.toJson(),
    };
  }
}

/// Model representing a lesson inside a phase
class PhaseLessonModel {
  final String id;
  final String title;
  final int minutes;
  final String? intro;
  final List<PhaseLessonSectionModel> sections;
  final String? example;
  final String? takeaway;

  const PhaseLessonModel({
    this.id = '',
    this.title = '',
    this.minutes = 0,
    this.intro,
    this.sections = const [],
    this.example,
    this.takeaway,
  });

  factory PhaseLessonModel.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'];
    List<PhaseLessonSectionModel> sectionsList = [];
    if (rawSections is List) {
      sectionsList = rawSections
          .whereType<Map<String, dynamic>>()
          .map((item) => PhaseLessonSectionModel.fromJson(item))
          .toList();
    }

    return PhaseLessonModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      minutes: _parseInt(json['minutes']),
      intro: json['intro']?.toString(),
      sections: sectionsList,
      example: json['example']?.toString(),
      takeaway: json['takeaway']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'minutes': minutes,
      if (intro != null) 'intro': intro,
      'sections': sections.map((s) => s.toJson()).toList(),
      if (example != null) 'example': example,
      if (takeaway != null) 'takeaway': takeaway,
    };
  }
}

/// Model representing a section inside a lesson
class PhaseLessonSectionModel {
  final String? h;
  final List<String> p;
  final List<String> list;

  const PhaseLessonSectionModel({
    this.h,
    this.p = const [],
    this.list = const [],
  });

  factory PhaseLessonSectionModel.fromJson(Map<String, dynamic> json) {
    final rawP = json['p'];
    List<String> pList = [];
    if (rawP is List) {
      pList = rawP.map((e) => e.toString()).toList();
    }

    final rawList = json['list'];
    List<String> listItems = [];
    if (rawList is List) {
      listItems = rawList.map((e) => e.toString()).toList();
    }

    return PhaseLessonSectionModel(
      h: json['h']?.toString(),
      p: pList,
      list: listItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (h != null) 'h': h,
      'p': p,
      'list': list,
    };
  }
}

/// Model representing a video inside a phase
class PhaseVideoModel {
  final String id;
  final String title;
  final String? description;
  final int duration;
  final String? mediaUrl;
  final String? thumbnailUrl;

  const PhaseVideoModel({
    this.id = '',
    this.title = '',
    this.description,
    this.duration = 0,
    this.mediaUrl,
    this.thumbnailUrl,
  });

  factory PhaseVideoModel.fromJson(Map<String, dynamic> json) {
    return PhaseVideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      duration: _parseInt(json['duration']),
      mediaUrl: json['mediaUrl']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'duration': duration,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

/// Model representing an activity inside a phase
class PhaseActivityModel {
  final String id;
  final String title;
  final String? purpose;
  final String? instructions;
  final List<PhaseActivityPromptModel> prompts;

  const PhaseActivityModel({
    this.id = '',
    this.title = '',
    this.purpose,
    this.instructions,
    this.prompts = const [],
  });

  factory PhaseActivityModel.fromJson(Map<String, dynamic> json) {
    final rawPrompts = json['prompts'];
    List<PhaseActivityPromptModel> promptsList = [];
    if (rawPrompts is List) {
      promptsList = rawPrompts
          .whereType<Map<String, dynamic>>()
          .map((item) => PhaseActivityPromptModel.fromJson(item))
          .toList();
    }

    return PhaseActivityModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      purpose: json['purpose']?.toString(),
      instructions: json['instructions']?.toString(),
      prompts: promptsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (purpose != null) 'purpose': purpose,
      if (instructions != null) 'instructions': instructions,
      'prompts': prompts.map((p) => p.toJson()).toList(),
    };
  }
}

/// Model representing a prompt in a phase activity
class PhaseActivityPromptModel {
  final String id;
  final String q;
  final List<String> chips;
  final bool optional;

  const PhaseActivityPromptModel({
    this.id = '',
    this.q = '',
    this.chips = const [],
    this.optional = true,
  });

  factory PhaseActivityPromptModel.fromJson(Map<String, dynamic> json) {
    final rawChips = json['chips'];
    List<String> chipsList = [];
    if (rawChips is List) {
      chipsList = rawChips.map((e) => e.toString()).toList();
    }

    return PhaseActivityPromptModel(
      id: json['id']?.toString() ?? '',
      q: json['q']?.toString() ?? '',
      chips: chipsList,
      optional: json['optional'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'q': q,
      'chips': chips,
      'optional': optional,
    };
  }
}

/// Model representing a quiz inside a phase
class PhaseQuizModel {
  final String id;
  final int? passThreshold;
  final List<PhaseQuizQuestionModel> questions;

  const PhaseQuizModel({
    this.id = '',
    this.passThreshold,
    this.questions = const [],
  });

  factory PhaseQuizModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    List<PhaseQuizQuestionModel> questionsList = [];
    if (rawQuestions is List) {
      questionsList = rawQuestions
          .whereType<Map<String, dynamic>>()
          .map((item) => PhaseQuizQuestionModel.fromJson(item))
          .toList();
    }

    return PhaseQuizModel(
      id: json['id']?.toString() ?? '',
      passThreshold: json['passThreshold'] != null
          ? _parseInt(json['passThreshold'])
          : null,
      questions: questionsList,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (passThreshold != null) 'passThreshold': passThreshold,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

/// Model representing a question in a phase quiz
class PhaseQuizQuestionModel {
  final String id;
  final String type;
  final String q;
  final List<String> options;
  final int answer;
  final String? explain;

  const PhaseQuizQuestionModel({
    this.id = '',
    this.type = '',
    this.q = '',
    this.options = const [],
    this.answer = 0,
    this.explain,
  });

  factory PhaseQuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<String> optionsList = [];
    if (rawOptions is List) {
      optionsList = rawOptions.map((e) => e.toString()).toList();
    }

    return PhaseQuizQuestionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      q: json['q']?.toString() ?? '',
      options: optionsList,
      answer: _parseInt(json['answer']),
      explain: json['explain']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'q': q,
      'options': options,
      'answer': answer,
      if (explain != null) 'explain': explain,
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
