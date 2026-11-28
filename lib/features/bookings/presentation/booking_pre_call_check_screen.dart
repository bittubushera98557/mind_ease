import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/zoom_video_sdk_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../data/models/appointment_model.dart';
import '../data/models/zoom_token_response_model.dart';

/// 5.09 Pre-call Hardware & Connection Check Screen
class BookingPreCallCheckScreen extends ConsumerStatefulWidget {
  final AppointmentModel? appointment;
  final ZoomTokenResponseModel? zoomToken;

  const BookingPreCallCheckScreen({
    Key? key,
    this.appointment,
    this.zoomToken,
  }) : super(key: key);

  @override
  ConsumerState<BookingPreCallCheckScreen> createState() =>
      _BookingPreCallCheckScreenState();
}

class _BookingPreCallCheckScreenState
    extends ConsumerState<BookingPreCallCheckScreen> {
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _requestInitialPermissions();
  }

  Future<void> _requestInitialPermissions() async {
    final zoomService = ref.read(zoomVideoSdkServiceProvider);
    await zoomService.requestPermissions();
  }

  Future<void> _handleJoinMeeting(AppointmentModel appt) async {
    setState(() {
      _isJoining = true;
    });

    try {
      final zoomService = ref.read(zoomVideoSdkServiceProvider);

      // Check and request runtime permissions before joining meeting
      final permissionsGranted = await zoomService.requestPermissions();
      if (!permissionsGranted) {
        final cameraStatus = await Permission.camera.status;
        final micStatus = await Permission.microphone.status;

        if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Camera and Microphone permissions are permanently denied. Please enable them in app settings.',
                ),
                action: SnackBarAction(
                  label: 'Settings',
                  onPressed: openAppSettings,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Camera and Microphone permissions are required to join the session.',
                ),
              ),
            );
          }
        }
        return;
      }

      final user = ref.read(authStateProvider).user;
      final userName = user?.name.isNotEmpty == true ? user!.name : 'Client';
      debugPrint("_handleJoinMeeting try");

      if (widget.zoomToken != null && widget.zoomToken!.token.isNotEmpty) {
        await zoomService.joinSession(
          sessionName: widget.zoomToken!.sessionName,
          token: widget.zoomToken!.token,
          userName: userName,
        );
      } else {
        await zoomService.initSdk();
      }

      if (mounted) {
        context.push(
          RouteNames.bookingInSession,
          extra: {
            'appointment': appt,
            'zoomToken': widget.zoomToken,
          },
        );
      }

    } catch (e) {
      debugPrint("_handleJoinMeeting catch");
      if (mounted) {
        context.push(
          RouteNames.bookingInSession,
          extra: {
            'appointment': appt,
            'zoomToken': widget.zoomToken,
          },
        );
      }
    } finally {
      debugPrint("_handleJoinMeeting finally");
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
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
          duration: '30 min video',
          format: 'Video',
          status: AppointmentStatus.upcoming,
          totalAmount: 180.0,
          bookingRef: 'ME-BK-020125',
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'READY TO JOIN?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Video Preview Box
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2420),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 40,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    // Controls overlay (bottom right inside preview box)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isCameraOff = !_isCameraOff;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isCameraOff
                                    ? AppColors.primary
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isCameraOff
                                    ? Icons.videocam_off_rounded
                                    : Icons.videocam_rounded,
                                size: 18,
                                color: _isCameraOff
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMicMuted = !_isMicMuted;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isMicMuted
                                    ? AppColors.primary
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isMicMuted
                                    ? Icons.mic_off_rounded
                                    : Icons.mic_rounded,
                                size: 18,
                                color: _isMicMuted
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Microphone',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                width: 3,
                                height: 8,
                                color: const Color(0xFF7EAA83)),
                            const SizedBox(width: 2),
                            Container(
                                width: 3,
                                height: 12,
                                color: const Color(0xFF7EAA83)),
                            const SizedBox(width: 2),
                            Container(
                                width: 3,
                                height: 16,
                                color: const Color(0xFF7EAA83)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                        height: 16, thickness: 1, color: Color(0xFFF4EFEA)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Camera',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Front camera',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                        height: 16, thickness: 1, color: Color(0xFFF4EFEA)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Connection',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7EE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Good',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF236539),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Privacy text
              Text(
                "MindEase only asks for camera and microphone access here. Session's encrypted end-to-end.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: AppColors.textTertiary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Join Session Button
              AppButton(
                text: 'Join session',
                isLoading: _isJoining,
                onPressed: () => _handleJoinMeeting(appt),
              ),
              const SizedBox(height: 8),

              Center(
                child: Text(
                  '${appt.therapistName} will join shortly',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
