import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/therapist_based_available_slots_resp.dart';
import '../models/therapists_list_resp.dart';

/// Repository for handling Therapists and Available Slots API operations
class TherapistsRepository {
  final DioClient _dioClient;

  TherapistsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches therapists list GET /therapists
  Future<TherapistsListResp> getTherapists() async {
    final response = await _dioClient.get<TherapistsListResp>(
      ApiEndpoints.therapistsList,
      fromJson: (json) => TherapistsListResp.fromJson(json),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load therapists');
  }

  /// Fetches available slots for a specific therapist GET /therapists/{therapistId}/slots
  Future<TherapistBasedAvailableSlotsResp> getTherapistSlots(
      String therapistId) async {
    final endpoint = ApiEndpoints.therapistBasedSlotsApi
        .replaceAll('{therapistId}', therapistId);

    final response = await _dioClient.get<TherapistBasedAvailableSlotsResp>(
      endpoint,
      fromJson: (json) => TherapistBasedAvailableSlotsResp.fromJson(
          json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load therapist slots');
  }
}
