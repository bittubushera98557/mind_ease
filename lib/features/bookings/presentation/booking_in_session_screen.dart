import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_videosdk/flutter_zoom_view.dart' as flutter_zoom_view;
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/zoom_video_sdk_service.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/appointment_model.dart';
import '../data/models/zoom_token_response_model.dart';

/// 5.10 In-Session Video Call Screen
class BookingInSessionScreen extends ConsumerStatefulWidget {
  final AppointmentModel? appointment;
  final ZoomTokenResponseModel? zoomToken;

  const BookingInSessionScreen({
    Key? key,
    this.appointment,
    this.zoomToken,
  }) : super(key: key);

  @override
  ConsumerState<BookingInSessionScreen> createState() =>
      _BookingInSessionScreenState();
}

class _BookingInSessionScreenState
    extends ConsumerState<BookingInSessionScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  ZoomVideoSdkUser? _mySelf;
  ZoomVideoSdkUser? _remoteTherapist;

  @override
  void initState() {
    super.initState();
    _loadSessionUsers();
  }

  Future<void> _loadSessionUsers() async {
    final zoomService = ref.read(zoomVideoSdkServiceProvider);
    final self = await zoomService.getMySelf();
    final remotes = await zoomService.getRemoteUsers();

    if (mounted) {
      setState(() {
        _mySelf = self;
        if (remotes.isNotEmpty) {
          _remoteTherapist = remotes.first;
        }
      });
    }
  }

  void _handleToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    ref.read(zoomVideoSdkServiceProvider).toggleAudio(_isMuted);
  }

  void _handleToggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
    });
    ref.read(zoomVideoSdkServiceProvider).toggleVideo(_isVideoOff);
  }

  void _handleSwitchCamera() {
    ref.read(zoomVideoSdkServiceProvider).switchCamera();
  }

  void _handleEndCall(AppointmentModel appt) {
    ref.read(zoomVideoSdkServiceProvider).leaveSession();
    context.go(RouteNames.bookingSessionEnded, extra: appt);
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment ??
        const AppointmentModel(
          id: 'bk-01',
          therapistName: 'Dr Priya Nair',
          therapistRole: 'Clinical Psychologist',
          therapistInitials: 'PN',
          dateString: 'Wed 4 Nov',
          dateBadge: 'NOV 4',
          timeString: '10:00 - 10:30 am',
          duration: '50 min',
          format: 'Video',
          status: AppointmentStatus.upcoming,
          totalAmount: 180.0,
          bookingRef: 'ME-BK-020125',
        );

    return Scaffold(
      backgroundColor: const Color(0xFF231B17),
      body: SafeArea(
        child: Stack(
          children: [
            // Therapist Main Video Feed Canvas
            Positioned.fill(
              child: _remoteTherapist != null
                  ? ZoomVideoSdkVideoView(
                      user: _remoteTherapist!,
                      sharing: false,
                      preview: false,
                      focused: true,
                      hasMultiWindow: false,
                      isResolutionHD: true,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2EFE0),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                appt.therapistInitials,
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF26682A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appt.therapistName,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Connecting to session...',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Top Bar Overlay (Timer & Connection)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '26:12',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF236539),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          appt.therapistName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Picture-in-Picture Inset Self View (Bottom Right)
            Positioned(
              right: 16,
              bottom: 100,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF382E28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _mySelf != null && !_isVideoOff
                      ? ZoomVideoSdkVideoView(
                          user: _mySelf!,
                          sharing: false,
                          preview: false,
                          focused: false,
                          hasMultiWindow: false,
                          isResolutionHD: false,
                        )
                      : Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 32,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                ),
              ),
            ),

            // Bottom Floating Controls Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Mute
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _handleToggleMute,
                    ),

                    // Camera
                    IconButton(
                      icon: Icon(
                        _isVideoOff
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _handleToggleVideo,
                    ),

                    // Flip camera
                    IconButton(
                      icon: const Icon(
                        Icons.cameraswitch_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _handleSwitchCamera,
                    ),

                    // Notes / Chat
                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),

                    // End Call (Red Button)
                    GestureDetector(
                      onTap: () => _handleEndCall(appt),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_end_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Native Video View wrapper widget for Zoom Video SDK user feed
class ZoomVideoSdkVideoView extends StatelessWidget {
  final ZoomVideoSdkUser user;
  final bool sharing;
  final bool preview;
  final bool focused;
  final bool hasMultiWindow;
  final bool isResolutionHD;

  const ZoomVideoSdkVideoView({
    Key? key,
    required this.user,
    this.sharing = false,
    this.preview = false,
    this.focused = false,
    this.hasMultiWindow = false,
    this.isResolutionHD = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      "userId": preview ? "" : user.userId,
      "sharing": sharing,
      "preview": preview,
      "focused": focused,
      "hasMultiCamera": false,
      "isPiPView": false,
      "videoAspect": VideoAspect.PanAndScan,
      "fullScreen": true,
      "resolution": isResolutionHD
          ? VideoResolution.Resolution720
          : VideoResolution.Resolution360,
    };

    return flutter_zoom_view.View(
      key: Key('zoom_view_${user.userId}_$sharing'),
      creationParams: creationParams,
    );
  }
}
