import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/appointment_model.dart';

/// 5.09 Pre-call Hardware & Connection Check Screen
class BookingPreCallCheckScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const BookingPreCallCheckScreen({
    Key? key,
    this.appointment,
  }) : super(key: key);

  @override
  State<BookingPreCallCheckScreen> createState() =>
      _BookingPreCallCheckScreenState();
}

class _BookingPreCallCheckScreenState extends State<BookingPreCallCheckScreen> {
  bool _isMicMuted = false;
  bool _isCameraOff = false;

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
                        backgroundColor: Colors.white.withOpacity(0.12),
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
                            Container(width: 3, height: 8, color: const Color(0xFF7EAA83)),
                            const SizedBox(width: 2),
                            Container(width: 3, height: 12, color: const Color(0xFF7EAA83)),
                            const SizedBox(width: 2),
                            Container(width: 3, height: 16, color: const Color(0xFF7EAA83)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 1, color: Color(0xFFF4EFEA)),

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
                    const Divider(height: 16, thickness: 1, color: Color(0xFFF4EFEA)),

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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                onPressed: () {
                  context.push(RouteNames.bookingInSession, extra: appt);
                },
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
