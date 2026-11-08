import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/config_response_model.dart';

/// Repository for handling App Config API (/config)
class ConfigRepository {
  final DioClient _dioClient;

  ConfigRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches system configuration GET /config
  Future<ConfigResponseModel> getConfig() async {
    final response = await _dioClient.get<ConfigResponseModel>(
      ApiEndpoints.config,
      fromJson: (json) => ConfigResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load app config');
  }
}
