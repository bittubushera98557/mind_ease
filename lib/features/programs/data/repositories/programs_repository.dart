import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/program_detail_response_model.dart';
import '../models/program_progress_response_model.dart';
import '../models/program_response_model.dart';

/// Repository for handling Programs API operations
class ProgramsRepository {
  final DioClient _dioClient;

  ProgramsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches published programs list GET /programs
  Future<ProgramResponseModel> getPrograms() async {
    final response = await _dioClient.get<ProgramResponseModel>(
      ApiEndpoints.programs,
      fromJson: (json) => ProgramResponseModel.fromJson(json),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load programs');
  }

  /// Fetches details for a specific program GET /programs/{programId}
  Future<ProgramDetailResponseModel> getProgramDetail(String programId) async {
    final endpoint = ApiEndpoints.programDetailWithId.replaceAll('{programId}', programId);
    final response = await _dioClient.get<ProgramDetailResponseModel>(
      endpoint,
      fromJson: (json) => ProgramDetailResponseModel.fromJson(json),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load program details');
  }

  /// Marks a lesson as read POST /me/programs/{programId}/lessons/{lessonId}/read
  Future<ProgramProgressResponseModel> markLessonAsRead({
    required String programId,
    required String lessonId,
  }) async {
    final endpoint = ApiEndpoints.readLesson
        .replaceAll('{programId}', programId)
        .replaceAll('{lessonId}', lessonId);
    final response = await _dioClient.post<ProgramProgressResponseModel>(
      endpoint,
      fromJson: (json) => ProgramProgressResponseModel.fromJson(json),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to mark lesson as read');
  }
}
