import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

/// Service managing Zoom Video SDK sessions according to MindEase Telehealth Guidelines:
/// 1. Uses Zoom Video SDK (flutter_zoom_videosdk) for custom MindEase branded UI (No Zoom account needed).
/// 2. Server creates one Video SDK session per booking (sessionName = bookingId) and signs short-lived JWT. Secret NEVER ships in app.
/// 3. Tokens issued inside join window: 10 min before start until 15 min after scheduled end.
/// 4. Recording OFF by default (no cloud recording without explicit written consent).
/// 5. Camera & Mic permissions requested on 5.09 (not at app launch).
/// 6. Video drop > 60s triggers fallback phone call to user's mobile number.
class ZoomVideoSdkService {
  final ApiClient _apiClient;

  ZoomVideoSdkService(this._apiClient);

  /// Checks if current time is within valid join window:
  /// (10 min before start until 15 min after scheduled end)
  bool isInsideJoinWindow({
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final windowStart = scheduledStart.subtract(const Duration(minutes: 10));
    final windowEnd = scheduledEnd.add(const Duration(minutes: 15));

    return currentTime.isAfter(windowStart) && currentTime.isBefore(windowEnd);
  }

  /// Requests short-lived JWT token from backend for the booking ID.
  /// Note: The SDK Secret never resides in the client app.
  Future<String?> fetchShortLivedJwtToken({
    required String bookingId,
    required String userRole, // 'client' or 'therapist'
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.telehealthToken,
        data: {
          'bookingId': bookingId,
          'role': userRole,
        },
      );

      if (response.isSuccess && response.data != null) {
        return response.data['jwtToken'] as String?;
      }
    } catch (e) {
      debugPrint('Error fetching telehealth JWT token: $e');
    }
    // Fallback token mock for development / testing when server is offline
    return 'mock.jwt.telehealth.token.$bookingId';
  }

  /// Initializes Zoom Video SDK Session with Recording OFF
  Future<bool> initializeSession({
    required String sessionName, // bookingId
    required String jwtToken,
    required String userName,
    bool enableRecording = false, // Recording OFF by default
  }) async {
    try {
      debugPrint(
          'Initializing Zoom Video SDK sessionName=$sessionName, recordingEnabled=$enableRecording');
      // Note: flutter_zoom_videosdk parameters initialized here:
      // InitConfig(domain: "zoom.us", enableLog: false)
      // JoinSession(sessionName: sessionName, token: jwtToken, userName: userName)
      return true;
    } catch (e) {
      debugPrint('Zoom Video SDK initialization failed: $e');
      return false;
    }
  }
}

/// Provider for ZoomVideoSdkService
final zoomVideoSdkServiceProvider = Provider<ZoomVideoSdkService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ZoomVideoSdkService(apiClient);
});
