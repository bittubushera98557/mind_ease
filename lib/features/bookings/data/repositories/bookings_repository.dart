import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/booking_response_model.dart';

/// Provider for Bookings repository
final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BookingsRepository(dioClient: dioClient);
});

/// Repository for handling Bookings API operations (POST / GET /me/bookings)
class BookingsRepository {
  final DioClient _dioClient;

  BookingsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches my bookings GET /me/bookings
  Future<BookingResponseModel> getBookings() async {
    final response = await _dioClient.get<BookingResponseModel>(
      ApiEndpoints.bookings,
      fromJson: (json) => BookingResponseModel.fromJson(json),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load bookings');
  }

  /// Creates a new booking POST /me/bookings
  Future<Map<String, dynamic>> createBooking({
    required String therapistId,
    required String startsAt,
    required List<String> focus,
    required String mobile,
    required String notes,
    required String paymentMethodId,
  }) async {
    final body = {
      'therapistId': therapistId,
      'startsAt': startsAt,
      'focus': focus,
      'mobile': mobile,
      'notes': notes,
      'paymentMethodId': paymentMethodId,
    };

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.bookings,
      body: body,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return {'status': 'success'};
      },
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to create booking');
  }
}
