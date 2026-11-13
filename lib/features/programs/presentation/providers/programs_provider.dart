import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/program_detail_response_model.dart';
import '../../data/models/program_progress_response_model.dart';
import '../../data/models/program_response_model.dart';
import '../../data/repositories/programs_repository.dart';

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

/// FutureProviderFamily that fetches program detail dynamically by programId
final programDetailProvider = FutureProvider.autoDispose
    .family<ProgramDetailResponseModel, String>((ref, programId) async {
  final repository = ref.watch(programsRepositoryProvider);
  return await repository.getProgramDetail(programId);
});

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
      if (programId.isNotEmpty) {
        _ref.invalidate(programDetailProvider(programId));
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
