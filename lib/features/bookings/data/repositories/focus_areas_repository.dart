import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/focus_area_resp.dart';

/// Repository for handling Focus Areas API operations
class FocusAreasRepository {
  final DioClient _dioClient;

  FocusAreasRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches focus areas list GET /focus-areas
  Future<List<FocusAreaResp>> getFocusAreas() async {
    final response = await _dioClient.get<List<FocusAreaResp>>(
      ApiEndpoints.focusAreas,
      fromJson: (json) {
        if (json is List) {
          return json
              .whereType<Map<String, dynamic>>()
              .map((item) => FocusAreaResp.fromJson(item))
              .toList();
        } else if (json is Map<String, dynamic>) {
          final listData = json['focusAreas'] ?? json['data'] ?? json['items'];
          if (listData is List) {
            return listData
                .whereType<Map<String, dynamic>>()
                .map((item) => FocusAreaResp.fromJson(item))
                .toList();
          }
        }
        return [];
      },
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load focus areas');
  }
}
