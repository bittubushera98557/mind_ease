import 'program_detail_response_model.dart';

/// Response model for POST /me/programs/{programId}/lessons/{lessonId}/read
class ProgramProgressResponseModel {
  final ProgramProgressDataModel? progress;
  final dynamic completion;
  final ApiErrorModel? error;

  const ProgramProgressResponseModel({
    this.progress,
    this.completion,
    this.error,
  });

  bool get isSuccess => error == null;

  factory ProgramProgressResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is Map<String, dynamic>) {
      return ProgramProgressResponseModel(
        error: ApiErrorModel.fromJson(json['error'] as Map<String, dynamic>),
      );
    }

    if (json.containsKey('progress') && json['progress'] is Map<String, dynamic>) {
      return ProgramProgressResponseModel(
        progress: ProgramProgressDataModel.fromJson(
            json['progress'] as Map<String, dynamic>),
        completion: json['completion'],
      );
    }

    return ProgramProgressResponseModel(
      progress: ProgramProgressDataModel.fromJson(json),
      completion: json['completion'],
    );
  }

  Map<String, dynamic> toJson() {
    if (error != null) {
      return {'error': error!.toJson()};
    }
    return {
      if (progress != null) 'progress': progress!.toJson(),
      'completion': completion,
    };
  }
}

class ProgramProgressDataModel {
  final String programId;
  final String contentVersion;
  final Map<String, PhaseProgressModel> phases;
  final Map<String, dynamic> phaseCompleted;
  final int points;
  final String? programCompletedAt;

  const ProgramProgressDataModel({
    this.programId = '',
    this.contentVersion = '',
    this.phases = const {},
    this.phaseCompleted = const {},
    this.points = 0,
    this.programCompletedAt,
  });

  factory ProgramProgressDataModel.fromJson(Map<String, dynamic> json) {
    final rawPhases = json['phases'];
    Map<String, PhaseProgressModel> phasesMap = {};
    if (rawPhases is Map<String, dynamic>) {
      rawPhases.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          phasesMap[key] = PhaseProgressModel.fromJson(value);
        }
      });
    }

    final rawPhaseCompleted = json['phaseCompleted'];
    Map<String, dynamic> phaseCompletedMap = {};
    if (rawPhaseCompleted is Map<String, dynamic>) {
      phaseCompletedMap = Map<String, dynamic>.from(rawPhaseCompleted);
    }

    return ProgramProgressDataModel(
      programId: json['programId']?.toString() ?? '',
      contentVersion: json['contentVersion']?.toString() ?? '',
      phases: phasesMap,
      phaseCompleted: phaseCompletedMap,
      points: json['points'] is num ? (json['points'] as num).toInt() : 0,
      programCompletedAt: json['programCompletedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'programId': programId,
      'contentVersion': contentVersion,
      'phases': phases.map((k, v) => MapEntry(k, v.toJson())),
      'phaseCompleted': phaseCompleted,
      'points': points,
      if (programCompletedAt != null) 'programCompletedAt': programCompletedAt,
    };
  }
}

class PhaseProgressModel {
  final bool unlocked;
  final String? completedAt;
  final int? pointsAwarded;
  final PhaseProgressCountsModel? counts;
  final Map<String, LessonProgressItemModel> lessons;
  final Map<String, dynamic> videos;
  final dynamic activity;
  final PhaseProgressQuizModel? quiz;

  const PhaseProgressModel({
    this.unlocked = false,
    this.completedAt,
    this.pointsAwarded,
    this.counts,
    this.lessons = const {},
    this.videos = const {},
    this.activity,
    this.quiz,
  });

  factory PhaseProgressModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'];
    Map<String, LessonProgressItemModel> lessonsMap = {};
    if (rawLessons is Map<String, dynamic>) {
      rawLessons.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          lessonsMap[key] = LessonProgressItemModel.fromJson(value);
        }
      });
    }

    final rawVideos = json['videos'];
    Map<String, dynamic> videosMap = {};
    if (rawVideos is Map<String, dynamic>) {
      videosMap = Map<String, dynamic>.from(rawVideos);
    }

    return PhaseProgressModel(
      unlocked: json['unlocked'] == true,
      completedAt: json['completedAt']?.toString(),
      pointsAwarded:
          json['pointsAwarded'] is num ? (json['pointsAwarded'] as num).toInt() : null,
      counts: json['counts'] is Map<String, dynamic>
          ? PhaseProgressCountsModel.fromJson(json['counts'] as Map<String, dynamic>)
          : null,
      lessons: lessonsMap,
      videos: videosMap,
      activity: json['activity'],
      quiz: json['quiz'] is Map<String, dynamic>
          ? PhaseProgressQuizModel.fromJson(json['quiz'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unlocked': unlocked,
      if (completedAt != null) 'completedAt': completedAt,
      if (pointsAwarded != null) 'pointsAwarded': pointsAwarded,
      if (counts != null) 'counts': counts!.toJson(),
      'lessons': lessons.map((k, v) => MapEntry(k, v.toJson())),
      'videos': videos,
      'activity': activity,
      if (quiz != null) 'quiz': quiz!.toJson(),
    };
  }
}

class PhaseProgressCountsModel {
  final ProgressItemCountModel? lessons;
  final ProgressItemCountModel? videos;
  final bool activity;
  final bool quiz;

  const PhaseProgressCountsModel({
    this.lessons,
    this.videos,
    this.activity = false,
    this.quiz = false,
  });

  factory PhaseProgressCountsModel.fromJson(Map<String, dynamic> json) {
    return PhaseProgressCountsModel(
      lessons: json['lessons'] is Map<String, dynamic>
          ? ProgressItemCountModel.fromJson(json['lessons'] as Map<String, dynamic>)
          : null,
      videos: json['videos'] is Map<String, dynamic>
          ? ProgressItemCountModel.fromJson(json['videos'] as Map<String, dynamic>)
          : null,
      activity: json['activity'] == true,
      quiz: json['quiz'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (lessons != null) 'lessons': lessons!.toJson(),
      if (videos != null) 'videos': videos!.toJson(),
      'activity': activity,
      'quiz': quiz,
    };
  }
}

class ProgressItemCountModel {
  final int done;
  final int total;

  const ProgressItemCountModel({
    this.done = 0,
    this.total = 0,
  });

  factory ProgressItemCountModel.fromJson(Map<String, dynamic> json) {
    return ProgressItemCountModel(
      done: json['done'] is num ? (json['done'] as num).toInt() : 0,
      total: json['total'] is num ? (json['total'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'done': done,
      'total': total,
    };
  }
}

class LessonProgressItemModel {
  final String? readAt;

  const LessonProgressItemModel({
    this.readAt,
  });

  factory LessonProgressItemModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressItemModel(
      readAt: json['readAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (readAt != null) 'readAt': readAt,
    };
  }
}

class PhaseProgressQuizModel {
  final List<dynamic> attempts;
  final bool passed;
  final String? passedAt;
  final int? bestScore;

  const PhaseProgressQuizModel({
    this.attempts = const [],
    this.passed = false,
    this.passedAt,
    this.bestScore,
  });

  factory PhaseProgressQuizModel.fromJson(Map<String, dynamic> json) {
    return PhaseProgressQuizModel(
      attempts: json['attempts'] is List ? json['attempts'] as List : const [],
      passed: json['passed'] == true,
      passedAt: json['passedAt']?.toString(),
      bestScore:
          json['bestScore'] is num ? (json['bestScore'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempts': attempts,
      'passed': passed,
      if (passedAt != null) 'passedAt': passedAt,
      if (bestScore != null) 'bestScore': bestScore,
    };
  }
}
