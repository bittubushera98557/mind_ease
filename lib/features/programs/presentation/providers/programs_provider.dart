import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/program_detail_response_model.dart';
import '../../data/models/program_progress_response_model.dart';
import '../../data/models/program_response_model.dart';
import '../../data/repositories/programs_repository.dart';

export '../../data/repositories/programs_repository.dart';

final programsRepositoryProvider = Provider<ProgramsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProgramsRepository(dioClient: dioClient);
});

/// FutureProvider that fetches programs list dynamically
final programsListProvider =
    FutureProvider.autoDispose<ProgramResponseModel>((ref) async {
  final repository = ref.watch(programsRepositoryProvider);
  return await repository.getPrograms();
});

/// Notifier Provider family that holds program detail and supports live progress updates
final programDetailProvider = StateNotifierProvider.family<
    ProgramDetailNotifier,
    AsyncValue<ProgramDetailResponseModel>,
    String>((ref, programId) {
  final repository = ref.watch(programsRepositoryProvider);
  return ProgramDetailNotifier(repository, programId);
});

class ProgramDetailNotifier
    extends StateNotifier<AsyncValue<ProgramDetailResponseModel>> {
  final ProgramsRepository _repository;
  final String programId;

  ProgramDetailNotifier(this._repository, this.programId)
      : super(const AsyncValue.loading()) {
    if (programId.isNotEmpty) {
      loadProgramDetail();
    }
  }

  Future<void> loadProgramDetail() async {
    try {
      final detail = await _repository.getProgramDetail(programId);
      state = AsyncValue.data(detail);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadProgramDetail();
  }

  /// Helper to extract ProgramProgressDataModel from dynamic API response
  ProgramProgressDataModel? _parseProgressFromResponse(dynamic response) {
    if (response is ProgramProgressResponseModel) {
      return response.progress;
    }
    if (response is Map<String, dynamic>) {
      if (response.containsKey('progress') && response['progress'] is Map<String, dynamic>) {
        return ProgramProgressDataModel.fromJson(
            response['progress'] as Map<String, dynamic>);
      } else if (response.containsKey('phases')) {
        return ProgramProgressDataModel.fromJson(response);
      }
    }
    return null;
  }

  /// Synchronously updates state with progress data returned from submission APIs
  void updateProgressFromResponse(dynamic response) {
    final progressData = _parseProgressFromResponse(response);
    if (progressData != null && state.hasValue && state.value != null) {
      final updated = state.value!.applyProgress(progressData);
      state = AsyncValue.data(updated);
    }
  }
}

/// Notifier Provider for marking a lesson as read
final markLessonAsReadNotifierProvider = StateNotifierProvider<
    MarkLessonAsReadNotifier, AsyncValue<ProgramProgressResponseModel?>>((ref) {
  final repository = ref.watch(programsRepositoryProvider);
  return MarkLessonAsReadNotifier(repository, ref);
});

class MarkLessonAsReadNotifier
    extends StateNotifier<AsyncValue<ProgramProgressResponseModel?>> {
  final ProgramsRepository _repository;
  final Ref _ref;

  MarkLessonAsReadNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<ProgramProgressResponseModel?> markLessonAsRead({
    required String programId,
    required String lessonId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.markLessonAsRead(
        programId: programId,
        lessonId: lessonId,
      );
      state = AsyncValue.data(response);
      if (programId.isNotEmpty && response.progress != null) {
        _ref
            .read(programDetailProvider(programId).notifier)
            .updateProgressFromResponse(response);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Notifier Provider for saving/completing an activity
final saveActivityNotifierProvider = StateNotifierProvider<
    SaveActivityNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repository = ref.watch(programsRepositoryProvider);
  return SaveActivityNotifier(repository, ref);
});

class SaveActivityNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ProgramsRepository _repository;
  final Ref _ref;

  SaveActivityNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>?> saveActivity({
    required String programId,
    required String activityId,
    required bool complete,
    required Map<String, dynamic> answers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.saveActivity(
        programId: programId,
        activityId: activityId,
        complete: complete,
        answers: answers,
      );
      state = AsyncValue.data(response);
      if (programId.isNotEmpty && response != null) {
        _ref
            .read(programDetailProvider(programId).notifier)
            .updateProgressFromResponse(response);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Notifier Provider for video progress tracking
final saveVideoProgressNotifierProvider = StateNotifierProvider<
    SaveVideoProgressNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repository = ref.watch(programsRepositoryProvider);
  return SaveVideoProgressNotifier(repository, ref);
});

class SaveVideoProgressNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ProgramsRepository _repository;
  final Ref _ref;

  SaveVideoProgressNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>?> saveVideoProgress({
    required String programId,
    required String videoId,
    required dynamic position,
    required String watched,
  }) async {
    try {
      final response = await _repository.saveVideoProgress(
        programId: programId,
        videoId: videoId,
        position: position,
        watched: watched,
      );
      state = AsyncValue.data(response);
      if (programId.isNotEmpty && response != null) {
        _ref
            .read(programDetailProvider(programId).notifier)
            .updateProgressFromResponse(response);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Notifier Provider for quiz submission
final submitQuizNotifierProvider = StateNotifierProvider<
    SubmitQuizNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repository = ref.watch(programsRepositoryProvider);
  return SubmitQuizNotifier(repository, ref);
});

class SubmitQuizNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ProgramsRepository _repository;
  final Ref _ref;

  SubmitQuizNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>?> submitQuiz({
    required String programId,
    required String quizId,
    required Map<String, int> answers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.submitQuiz(
        programId: programId,
        quizId: quizId,
        answers: answers,
      );
      state = AsyncValue.data(response);
      if (programId.isNotEmpty && response != null) {
        _ref
            .read(programDetailProvider(programId).notifier)
            .updateProgressFromResponse(response);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
