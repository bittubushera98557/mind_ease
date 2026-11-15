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

  /// Saves or submits an activity POST /me/programs/{programId}/activities/{activityId}
  Future<Map<String, dynamic>> saveActivity({
    required String programId,
    required String activityId,
    required bool complete,
    required Map<String, dynamic> answers,
  }) async {
    final endpoint = ApiEndpoints.saveActivity
        .replaceAll('{programId}', programId)
        .replaceAll('{activityId}', activityId);

    final body = {
      'complete': complete,
      'answers': answers,
    };

    final response = await _dioClient.post<Map<String, dynamic>>(
      endpoint,
      body: body,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'status': 'success'};
      },
    );

    if (response.data != null) {
      final data = response.data!;
      if (data.containsKey('error') && data['error'] != null) {
        final err = data['error'];
        String msg = 'Failed to save activity';
        if (err is Map<String, dynamic> && err['message'] != null) {
          msg = err['message'].toString();
        } else if (err is String) {
          msg = err;
        }
        throw Exception(msg);
      }
      return data;
    }

    throw Exception(response.message ?? 'Failed to save activity');
  }

  /// Saves video playback progress POST /me/programs/{programId}/videos/{videoId}/progress
  Future<Map<String, dynamic>> saveVideoProgress({
    required String programId,
    required String videoId,
    required dynamic position,
    required String watched,
  }) async {
    final endpoint = ApiEndpoints.videoProgress
        .replaceAll('{programId}', programId)
        .replaceAll('{videoId}', videoId);

    final body = {
      'position': position,
      'watched': watched,
    };

    final response = await _dioClient.post<Map<String, dynamic>>(
      endpoint,
      body: body,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'status': 'success'};
      },
    );

    if (response.data != null) {
      final data = response.data!;
      if (data.containsKey('error') && data['error'] != null) {
        final err = data['error'];
        String msg = 'Failed to save video progress';
        if (err is Map<String, dynamic> && err['message'] != null) {
          msg = err['message'].toString();
        } else if (err is String) {
          msg = err;
        }
        throw Exception(msg);
      }
      return data;
    }

    throw Exception(response.message ?? 'Failed to save video progress');
  }

  /// Submits phase quiz answers POST /me/programs/{programId}/quizzes/{quizId}/submit
  Future<Map<String, dynamic>> submitQuiz({
    required String programId,
    required String quizId,
    required Map<String, int> answers,
  }) async {
    final effectiveQuizId = quizId.isNotEmpty ? quizId : 'p1q';
    final endpoint = ApiEndpoints.submitQuiz
        .replaceAll('{programId}', programId)
        .replaceAll('{quizId}', effectiveQuizId);

    final body = {
      'answers': answers,
    };

    final response = await _dioClient.post<Map<String, dynamic>>(
      endpoint,
      body: body,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'status': 'success'};
      },
    );

    if (response.data != null) {
      final data = response.data!;
      if (data.containsKey('error') && data['error'] != null) {
        final err = data['error'];
        String msg = 'Failed to submit quiz';
        if (err is Map<String, dynamic> && err['message'] != null) {
          msg = err['message'].toString();
        } else if (err is String) {
          msg = err;
        }
        throw Exception(msg);
      }
      return data;
    }

    throw Exception(response.message ?? 'Failed to submit quiz');
  }
}
