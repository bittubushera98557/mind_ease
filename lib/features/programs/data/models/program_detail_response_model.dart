import 'program_progress_response_model.dart';

/// Model representing full program detail response from /programs/{programId}
class ProgramDetailResponseModel {
  final String id;
  final String title;
  final String short;
  final String? intro;
  final List<String> learn;
  final String? disclaimer;
  final String? status;
  final String? contentVersion;
  final int displayOrder;
  final String? coverImage;
  final List<ProgramPhaseModel> phases;
  final int? userPoints;
  final ApiErrorModel? error;

  const ProgramDetailResponseModel({
    this.id = '',
    this.title = '',
    this.short = '',
    this.intro,
    this.learn = const [],
    this.disclaimer,
    this.status,
    this.contentVersion,
    this.displayOrder = 0,
    this.coverImage,
    this.phases = const [],
    this.userPoints,
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
      status: json['status']?.toString(),
      contentVersion: json['contentVersion']?.toString(),
      displayOrder: _parseInt(json['displayOrder']),
      coverImage: json['coverImage']?.toString(),
      phases: phasesList,
      userPoints: json['userPoints'] is num
          ? (json['userPoints'] as num).toInt()
          : (json['points'] is num ? (json['points'] as num).toInt() : null),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  ProgramDetailResponseModel copyWith({
    String? id,
    String? title,
    String? short,
    String? intro,
    List<String>? learn,
    String? disclaimer,
    String? status,
    String? contentVersion,
    int? displayOrder,
    String? coverImage,
    List<ProgramPhaseModel>? phases,
    int? userPoints,
    ApiErrorModel? error,
  }) {
    return ProgramDetailResponseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      short: short ?? this.short,
      intro: intro ?? this.intro,
      learn: learn ?? this.learn,
      disclaimer: disclaimer ?? this.disclaimer,
      status: status ?? this.status,
      contentVersion: contentVersion ?? this.contentVersion,
      displayOrder: displayOrder ?? this.displayOrder,
      coverImage: coverImage ?? this.coverImage,
      phases: phases ?? this.phases,
      userPoints: userPoints ?? this.userPoints,
      error: error ?? this.error,
    );
  }

  /// Merges updated progress data (from submission APIs) into current program detail
  ProgramDetailResponseModel applyProgress(ProgramProgressDataModel progress) {
    final updatedPhases = phases.map((phase) {
      PhaseProgressModel? phaseProgress = progress.phases[phase.id];
      if (phaseProgress == null) {
        final key = 'p${phase.number > 0 ? phase.number : (phases.indexOf(phase) + 1)}';
        phaseProgress = progress.phases[key];
      }

      if (phaseProgress != null) {
        return phase.applyProgress(phaseProgress);
      }
      return phase;
    }).toList();

    return copyWith(
      phases: updatedPhases,
      userPoints: progress.points > 0 ? progress.points : userPoints,
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
      'title': title,
      'short': short,
      if (intro != null) 'intro': intro,
      'learn': learn,
      if (disclaimer != null) 'disclaimer': disclaimer,
      if (status != null) 'status': status,
      if (contentVersion != null) 'contentVersion': contentVersion,
      'displayOrder': displayOrder,
      if (coverImage != null) 'coverImage': coverImage,
      'phases': phases.map((p) => p.toJson()).toList(),
      if (userPoints != null) 'userPoints': userPoints,
    };
  }
}

/// Model representing unlock requirements for a phase
class UnlockRequirementsModel {
  final bool previousPhaseCompleted;

  const UnlockRequirementsModel({
    this.previousPhaseCompleted = false,
  });

  factory UnlockRequirementsModel.fromJson(Map<String, dynamic> json) {
    return UnlockRequirementsModel(
      previousPhaseCompleted: json['previousPhaseCompleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousPhaseCompleted': previousPhaseCompleted,
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
  final UnlockRequirementsModel? unlockRequirements;

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
    this.unlockRequirements,
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
      unlockRequirements: json['unlockRequirements'] is Map<String, dynamic>
          ? UnlockRequirementsModel.fromJson(
              json['unlockRequirements'] as Map<String, dynamic>)
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  ProgramPhaseModel copyWith({
    String? id,
    int? number,
    String? title,
    String? description,
    List<String>? objectives,
    String? color,
    int? pointsAwarded,
    List<PhaseLessonModel>? lessons,
    List<PhaseVideoModel>? videos,
    PhaseActivityModel? activity,
    PhaseQuizModel? quiz,
    UnlockRequirementsModel? unlockRequirements,
  }) {
    return ProgramPhaseModel(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      objectives: objectives ?? this.objectives,
      color: color ?? this.color,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      lessons: lessons ?? this.lessons,
      videos: videos ?? this.videos,
      activity: activity ?? this.activity,
      quiz: quiz ?? this.quiz,
      unlockRequirements: unlockRequirements ?? this.unlockRequirements,
    );
  }

  /// Merges PhaseProgressModel into this phase instance
  ProgramPhaseModel applyProgress(PhaseProgressModel phaseProgress) {
    // Update lessons
    final updatedLessons = lessons.map((lesson) {
      bool isRead = lesson.isRead;
      if (phaseProgress.lessons.containsKey(lesson.id)) {
        final item = phaseProgress.lessons[lesson.id];
        if (item?.readAt != null && item!.readAt!.isNotEmpty) {
          isRead = true;
        }
      }
      if (phaseProgress.counts?.lessons != null &&
          phaseProgress.counts!.lessons!.done >= lessons.length &&
          lessons.isNotEmpty) {
        isRead = true;
      }
      return lesson.copyWith(isRead: isRead);
    }).toList();

    // Update videos
    final updatedVideos = videos.map((video) {
      bool isWatched = video.isVideoWatched;
      if (phaseProgress.videos.containsKey(video.id)) {
        final vVal = phaseProgress.videos[video.id];
        if (vVal is Map<String, dynamic>) {
          final percent = vVal['percent'];
          final completedAt = vVal['completedAt'];
          final watchedSecs = vVal['watchedSeconds'] ?? vVal['position'];

          if (percent == 100 ||
              (completedAt != null && completedAt.toString().isNotEmpty) ||
              (watchedSecs is num && video.duration > 0 && watchedSecs >= video.duration)) {
            isWatched = true;
          }
        } else if (vVal == true) {
          isWatched = true;
        }
      }
      if (phaseProgress.counts?.videos != null &&
          phaseProgress.counts!.videos!.done >= videos.length &&
          videos.isNotEmpty) {
        isWatched = true;
      }
      return video.copyWith(isVideoWatched: isWatched);
    }).toList();

    // Update activity
    PhaseActivityModel? updatedActivity = activity;
    if (activity != null) {
      bool isCompleted = activity!.isCompleted;
      bool isDraft = activity!.isDraft;
      List<PhaseActivityPromptModel> updatedPrompts = activity!.prompts;

      if (phaseProgress.activity != null) {
        if (phaseProgress.activity is Map<String, dynamic>) {
          final actMap = phaseProgress.activity as Map<String, dynamic>;
          isCompleted = actMap['complete'] == true;
          isDraft = actMap['complete'] == false;

          final rawAnswers = actMap['answers'];
          if (rawAnswers is Map<String, dynamic> && updatedPrompts.isNotEmpty) {
            updatedPrompts = updatedPrompts.map((prompt) {
              final qId = prompt.id.isNotEmpty ? prompt.id : 'q${updatedPrompts.indexOf(prompt) + 1}';
              if (rawAnswers.containsKey(qId) || rawAnswers.containsKey(prompt.id)) {
                final answerJson = rawAnswers[qId] ?? rawAnswers[prompt.id];
                final parsedAnswer = PhaseActivityPromptAnswerModel.fromJson(answerJson);
                return prompt.copyWith(answer: parsedAnswer);
              }
              return prompt;
            }).toList();
          }
        } else if (phaseProgress.activity == true) {
          isCompleted = true;
        }
      }
      if (phaseProgress.counts?.activity == true) {
        isCompleted = true;
      }

      updatedActivity = activity!.copyWith(
        isCompleted: isCompleted,
        isDraft: isDraft,
        prompts: updatedPrompts,
      );
    }

    // Update quiz
    PhaseQuizModel? updatedQuiz = quiz;
    if (quiz != null) {
      bool isPassed = quiz!.isPassed;
      bool isCompleted = quiz!.isCompleted;

      if (phaseProgress.quiz != null) {
        isPassed = phaseProgress.quiz!.passed;
        isCompleted = phaseProgress.quiz!.passed || phaseProgress.quiz!.attempts.isNotEmpty;
      }
      if (phaseProgress.counts?.quiz == true) {
        isPassed = true;
        isCompleted = true;
      }

      updatedQuiz = quiz!.copyWith(
        isPassed: isPassed,
        isCompleted: isCompleted,
      );
    }

    return copyWith(
      lessons: updatedLessons,
      videos: updatedVideos,
      activity: updatedActivity,
      quiz: updatedQuiz,
      pointsAwarded: phaseProgress.pointsAwarded ?? pointsAwarded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'description': description,
      'objectives': objectives,
      'color': color,
      if (pointsAwarded != null) 'pointsAwarded': pointsAwarded,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'videos': videos.map((v) => v.toJson()).toList(),
      if (activity != null) 'activity': activity!.toJson(),
      if (quiz != null) 'quiz': quiz!.toJson(),
      if (unlockRequirements != null)
        'unlockRequirements': unlockRequirements!.toJson(),
    };
  }
}

/// Model representing a lesson inside a phase
class PhaseLessonModel {
  final String id;
  final String title;
  final int minutes;
  final String? intro;
  final bool isRead;
  final List<PhaseLessonSectionModel> sections;
  final String? example;
  final String? takeaway;
  final int displayOrder;

  const PhaseLessonModel({
    this.id = '',
    this.title = '',
    this.minutes = 0,
    this.intro,
    this.isRead = false,
    this.sections = const [],
    this.example,
    this.takeaway,
    this.displayOrder = 0,
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
      isRead: json['is_read'] == true || json['isRead'] == true,
      sections: sectionsList,
      example: json['example']?.toString(),
      takeaway: json['takeaway']?.toString(),
      displayOrder: _parseInt(json['displayOrder']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  PhaseLessonModel copyWith({
    String? id,
    String? title,
    int? minutes,
    String? intro,
    bool? isRead,
    List<PhaseLessonSectionModel>? sections,
    String? example,
    String? takeaway,
    int? displayOrder,
  }) {
    return PhaseLessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      intro: intro ?? this.intro,
      isRead: isRead ?? this.isRead,
      sections: sections ?? this.sections,
      example: example ?? this.example,
      takeaway: takeaway ?? this.takeaway,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'minutes': minutes,
      if (intro != null) 'intro': intro,
      'is_read': isRead,
      'sections': sections.map((s) => s.toJson()).toList(),
      if (example != null) 'example': example,
      if (takeaway != null) 'takeaway': takeaway,
      'displayOrder': displayOrder,
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
    } else if (rawP is String) {
      pList = [rawP];
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

/// Model representing completion rule for a video
class CompletionRuleModel {
  final String type;
  final bool useConfig;

  const CompletionRuleModel({
    this.type = '',
    this.useConfig = true,
  });

  factory CompletionRuleModel.fromJson(Map<String, dynamic> json) {
    return CompletionRuleModel(
      type: json['type']?.toString() ?? '',
      useConfig: json['useConfig'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'useConfig': useConfig,
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
  final CompletionRuleModel? completionRule;
  final bool isVideoWatched;

  const PhaseVideoModel({
    this.id = '',
    this.title = '',
    this.description,
    this.duration = 0,
    this.mediaUrl,
    this.thumbnailUrl,
    this.completionRule,
    this.isVideoWatched = false,
  });

  factory PhaseVideoModel.fromJson(Map<String, dynamic> json) {
    return PhaseVideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      duration: _parseInt(json['duration']),
      mediaUrl: json['mediaUrl']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      completionRule: json['completionRule'] is Map<String, dynamic>
          ? CompletionRuleModel.fromJson(
              json['completionRule'] as Map<String, dynamic>)
          : null,
      isVideoWatched: json['is_video_watched'] == true || json['isVideoWatched'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  PhaseVideoModel copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    String? mediaUrl,
    String? thumbnailUrl,
    CompletionRuleModel? completionRule,
    bool? isVideoWatched,
  }) {
    return PhaseVideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      completionRule: completionRule ?? this.completionRule,
      isVideoWatched: isVideoWatched ?? this.isVideoWatched,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'duration': duration,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      if (completionRule != null) 'completionRule': completionRule!.toJson(),
      'is_video_watched': isVideoWatched,
    };
  }
}

/// Model representing an activity inside a phase
class PhaseActivityModel {
  final String id;
  final String title;
  final String? purpose;
  final String? instructions;
  final bool isDraft;
  final bool isCompleted;
  final List<PhaseActivityPromptModel> prompts;

  const PhaseActivityModel({
    this.id = '',
    this.title = '',
    this.purpose,
    this.instructions,
    this.isDraft = false,
    this.isCompleted = false,
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
      isDraft: json['is_draft'] == true || json['isDraft'] == true,
      isCompleted: json['is_completed'] == true || json['isCompleted'] == true,
      prompts: promptsList,
    );
  }

  PhaseActivityModel copyWith({
    String? id,
    String? title,
    String? purpose,
    String? instructions,
    bool? isDraft,
    bool? isCompleted,
    List<PhaseActivityPromptModel>? prompts,
  }) {
    return PhaseActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      purpose: purpose ?? this.purpose,
      instructions: instructions ?? this.instructions,
      isDraft: isDraft ?? this.isDraft,
      isCompleted: isCompleted ?? this.isCompleted,
      prompts: prompts ?? this.prompts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (purpose != null) 'purpose': purpose,
      if (instructions != null) 'instructions': instructions,
      'is_draft': isDraft,
      'is_completed': isCompleted,
      'prompts': prompts.map((p) => p.toJson()).toList(),
    };
  }
}

/// Model representing answer data in a phase activity prompt
class PhaseActivityPromptAnswerModel {
  final String? text;
  final List<String> chips;

  const PhaseActivityPromptAnswerModel({
    this.text,
    this.chips = const [],
  });

  factory PhaseActivityPromptAnswerModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final rawChips = json['chips'];
      List<String> chipsList = [];
      if (rawChips is List) {
        chipsList = rawChips.map((e) => e.toString()).toList();
      }
      return PhaseActivityPromptAnswerModel(
        text: json['text']?.toString(),
        chips: chipsList,
      );
    } else if (json is String) {
      return PhaseActivityPromptAnswerModel(text: json);
    }
    return const PhaseActivityPromptAnswerModel();
  }

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text,
      'chips': chips,
    };
  }
}

/// Model representing a prompt in a phase activity
class PhaseActivityPromptModel {
  final String id;
  final String q;
  final List<String> chips;
  final bool optional;
  final String? responseType;
  final PhaseActivityPromptAnswerModel? answer;

  const PhaseActivityPromptModel({
    this.id = '',
    this.q = '',
    this.chips = const [],
    this.optional = true,
    this.responseType,
    this.answer,
  });

  /// Helper getter for prompt text answer
  String? get savedText => answer?.text;

  /// Helper getter for prompt selected chips
  List<String> get savedChips => answer?.chips ?? const [];

  factory PhaseActivityPromptModel.fromJson(Map<String, dynamic> json) {
    final rawChips = json['chips'];
    List<String> chipsList = [];
    if (rawChips is List) {
      chipsList = rawChips.map((e) => e.toString()).toList();
    }

    PhaseActivityPromptAnswerModel? parsedAnswer;
    if (json.containsKey('answer') && json['answer'] != null) {
      parsedAnswer = PhaseActivityPromptAnswerModel.fromJson(json['answer']);
    }

    return PhaseActivityPromptModel(
      id: json['id']?.toString() ?? '',
      q: json['q']?.toString() ?? '',
      chips: chipsList,
      optional: json['optional'] != false,
      responseType: json['responseType']?.toString(),
      answer: parsedAnswer,
    );
  }

  PhaseActivityPromptModel copyWith({
    String? id,
    String? q,
    List<String>? chips,
    bool? optional,
    String? responseType,
    PhaseActivityPromptAnswerModel? answer,
  }) {
    return PhaseActivityPromptModel(
      id: id ?? this.id,
      q: q ?? this.q,
      chips: chips ?? this.chips,
      optional: optional ?? this.optional,
      responseType: responseType ?? this.responseType,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'q': q,
      'chips': chips,
      'optional': optional,
      if (responseType != null) 'responseType': responseType,
      if (answer != null) 'answer': answer!.toJson(),
    };
  }
}

/// Model representing a quiz inside a phase
class PhaseQuizModel {
  final String id;
  final String? title;
  final bool isCompleted;
  final bool isPassed;
  final int? passThreshold;
  final List<PhaseQuizQuestionModel> questions;

  const PhaseQuizModel({
    this.id = '',
    this.title,
    this.isCompleted = false,
    this.isPassed = false,
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
      title: json['title']?.toString(),
      isCompleted: json['is_completed'] == true || json['isCompleted'] == true,
      isPassed: json['is_passed'] == true || json['isPassed'] == true,
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

  PhaseQuizModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isPassed,
    int? passThreshold,
    List<PhaseQuizQuestionModel>? questions,
  }) {
    return PhaseQuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isPassed: isPassed ?? this.isPassed,
      passThreshold: passThreshold ?? this.passThreshold,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      'is_completed': isCompleted,
      'is_passed': isPassed,
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
  final int? userAnswer;

  const PhaseQuizQuestionModel({
    this.id = '',
    this.type = '',
    this.q = '',
    this.options = const [],
    this.answer = 0,
    this.explain,
    this.userAnswer,
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
      userAnswer: json['user_answer'] != null || json['userAnswer'] != null
          ? _parseInt(json['user_answer'] ?? json['userAnswer'])
          : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  PhaseQuizQuestionModel copyWith({
    String? id,
    String? type,
    String? q,
    List<String>? options,
    int? answer,
    String? explain,
    int? userAnswer,
  }) {
    return PhaseQuizQuestionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      q: q ?? this.q,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      explain: explain ?? this.explain,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'q': q,
      'options': options,
      'answer': answer,
      if (explain != null) 'explain': explain,
      if (userAnswer != null) 'user_answer': userAnswer,
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
