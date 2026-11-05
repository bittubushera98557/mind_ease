import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/points_model.dart';

/// Repository for handling Points API operations
class PointsRepository {
  final DioClient _dioClient;

  PointsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches user points details GET /me/points
  Future<PointsModel> getPoints() async {
    final response = await _dioClient.get<PointsModel>(
      ApiEndpoints.mePoints,
      fromJson: (json) => PointsModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load points');
  }
}
