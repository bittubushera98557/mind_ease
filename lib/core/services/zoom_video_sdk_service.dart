import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:permission_handler/permission_handler.dart';

import '../network/api_client.dart';

/// Service managing real Zoom Video SDK sessions dynamically
class ZoomVideoSdkService {
  final ApiClient _apiClient;
  final ZoomVideoSdk _zoomSdk = ZoomVideoSdk();
  final ZoomVideoSdkEventListener _eventListener = ZoomVideoSdkEventListener();

  ZoomVideoSdkService(this._apiClient);

  ApiClient get apiClient => _apiClient;
  ZoomVideoSdk get zoomSdk => _zoomSdk;
  ZoomVideoSdkEventListener get eventListener => _eventListener;

  /// Requests Camera and Microphone permissions required by Zoom Video SDK
  Future<bool> requestPermissions() async {
    try {
      final statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

      final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
      final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

      debugPrint('Zoom SDK permissions - Camera: $cameraGranted, Mic: $micGranted');
      return cameraGranted && micGranted;
    } catch (e) {
      debugPrint('Zoom SDK requestPermissions error: $e');
      return false;
    }
  }

  /// Initializes Zoom Video SDK
  Future<bool> initSdk() async {
    try {
      debugPrint('Zoom SDK initSdk try');

      final config = InitConfig(
        domain: "zoom.us",
        enableLog: kDebugMode,
      );
      await _zoomSdk.initSdk(config);
      return true;
    } catch (e) {
      debugPrint('Zoom SDK initSdk error: $e');
      return false;
    }
  }

  /// Joins Zoom Session dynamically with sessionName, token, and userName
  Future<bool> joinSession({
    required String sessionName,
    required String token,
    required String userName,
    String? sessionPassword,
  }) async {
    try {
      await requestPermissions();
      await initSdk();
      final joinConfig = JoinSessionConfig(
        sessionName: sessionName.isNotEmpty ? sessionName : 'mindease-session',
        token: token,
        userName: userName.isNotEmpty ? userName : 'Client',
        sessionPassword: sessionPassword ?? '',
        audioOptions: {
          'connect': true,
          'mute': false,
          'autoAdjustSpeakerVolume': true,
        },
        videoOptions: {
          'localVideoOn': true,
        },
      );
      await _zoomSdk.joinSession(joinConfig);
      debugPrint('Zoom SDK joinSession Successfully joined Zoom session: $sessionName');
      return true;
    } catch (e) {
      debugPrint('Zoom SDK joinSession error: $e');
      return false;
    }
  }

  /// Alias for joinSession/joinMeeting
  Future<bool> joinMeeting({
    required String meetingNumber,
    required String userName,
    String? password,
    String? jwtToken,
  }) async {
    return joinSession(
      sessionName: meetingNumber,
      token: jwtToken ?? '',
      userName: userName,
      sessionPassword: password,
    );
  }

  /// Leaves current Zoom Session
  Future<void> leaveSession({bool endForCall = false}) async {
    try {
      await _zoomSdk.leaveSession(endForCall);
    } catch (e) {
      debugPrint('Zoom SDK leaveSession error: $e');
    }
  }

  /// Toggle Audio (Mute / Unmute)
  Future<void> toggleAudio(bool isMuted) async {
    try {
      final mySelf = await _zoomSdk.session.getMySelf();
      if (mySelf != null) {
        final userId = mySelf.userId;
        if (isMuted) {
          await _zoomSdk.audioHelper.muteAudio(userId);
        } else {
          await _zoomSdk.audioHelper.unMuteAudio(userId);
        }
      }
    } catch (e) {
      debugPrint('Zoom SDK toggleAudio error: $e');
    }
  }

  /// Toggle Video (Start / Stop Camera)
  Future<void> toggleVideo(bool isVideoOff) async {
    try {
      if (isVideoOff) {
        await _zoomSdk.videoHelper.stopVideo();
      } else {
        await _zoomSdk.videoHelper.startVideo();
      }
    } catch (e) {
      debugPrint('Zoom SDK toggleVideo error: $e');
    }
  }

  /// Switch Camera (Front / Back)
  Future<void> switchCamera() async {
    try {
      await _zoomSdk.videoHelper.switchCamera(null);
    } catch (e) {
      debugPrint('Zoom SDK switchCamera error: $e');
    }
  }

  /// Get current user (self)
  Future<ZoomVideoSdkUser?> getMySelf() async {
    try {
      return await _zoomSdk.session.getMySelf();
    } catch (e) {
      return null;
    }
  }

  /// Get remote users in session
  Future<List<ZoomVideoSdkUser>> getRemoteUsers() async {
    try {
      final remoteList = await _zoomSdk.session.getRemoteUsers();
      return remoteList ?? [];
    } catch (e) {
      return [];
    }
  }

  void listenToEvents({
    void Function(dynamic status)? onStatusChanged,
    void Function(dynamic reason)? onEnded,
  }) {
    if (onStatusChanged != null) {
      _eventListener.addListener(EventType.onSessionJoin, onStatusChanged);
    }
    if (onEnded != null) {
      _eventListener.addListener(EventType.onSessionLeave, onEnded);
    }
  }

  void dispose() {}
}

typedef ZoomMeetingSdkService = ZoomVideoSdkService;

/// Provider for ZoomVideoSdkService
final zoomVideoSdkServiceProvider = Provider<ZoomVideoSdkService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ZoomVideoSdkService(apiClient);
});

final zoomMeetingSdkServiceProvider = zoomVideoSdkServiceProvider;
