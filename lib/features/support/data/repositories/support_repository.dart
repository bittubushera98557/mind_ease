import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/support_resources_response_model.dart';

/// Repository for handling Support Resources API operations
class SupportRepository {
  final DioClient _dioClient;

  SupportRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches support resources list GET /support-resources
  Future<SupportResourcesResponseModel> getSupportResources() async {
    final response = await _dioClient.get<SupportResourcesResponseModel>(
      ApiEndpoints.supportResources,
      fromJson: (json) =>
          SupportResourcesResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load support resources');
  }
}
