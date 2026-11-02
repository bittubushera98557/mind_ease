import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/program_detail_response_model.dart';
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
}
