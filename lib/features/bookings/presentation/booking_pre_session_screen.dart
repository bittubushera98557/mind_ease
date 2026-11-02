import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/appointment_model.dart';
import 'widgets/cancel_session_bottom_sheet.dart';

/// 5.07 Appointment Detail / Pre-Session Screen
class BookingPreSessionScreen extends StatelessWidget {
  final AppointmentModel? appointment;

  const BookingPreSessionScreen({
    Key? key,
    this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appt = appointment ??
        const AppointmentModel(
          id: 'bk-01',
          therapistName: 'Dr Priya Nair',
          therapistRole: 'Clinical Psychologist',
          therapistInitials: 'PN',
          dateString: 'Wed 4 Nov',
          dateBadge: 'NOV 4',
          timeString: '10:00 - 10:30 am',
          duration: '30 min video',
          format: 'Video in MindEase',
          status: AppointmentStatus.upcoming,
          isNextSession: true,
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
                        'APPOINTMENT',
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

              // Therapist & Date Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    // Therapist Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2EFE0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              appt.therapistInitials,
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF26682A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appt.therapistName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                appt.therapistRole,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7EE),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBCE3C4)),
                          ),
                          child: Text(
                            'Dr Video',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF236539),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    const SizedBox(height: 14),

                    // Date & Time
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                appt.dateString,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                appt.timeString,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Starts in 8 min badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEEEC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_filled_rounded,
                            size: 13,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Starts in 8 min',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Join session button
                    AppButton(
                      text: 'Join session',
                      onPressed: () {
                        context.push(RouteNames.bookingPreCallCheck,
                            extra: appt);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Before your session section
              Text(
                'Before your session',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    _buildGuideItem(
                      icon: Icons.home_outlined,
                      title: 'Find a quiet private space',
                    ),
                    const Divider(
                        height: 16, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildGuideItem(
                      icon: Icons.headphones_outlined,
                      title: 'Headphones help with privacy and sound',
                    ),
                    const Divider(
                        height: 16, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildGuideItem(
                      icon: Icons.wifi_rounded,
                      title: 'Use Wi-Fi or strong mobile data',
                    ),
                    const Divider(
                        height: 16, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildGuideItem(
                      icon: Icons.phone_outlined,
                      title:
                          'If video drops, your therapist calls 04XX XXX XXX',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Action Tiles Card (Reschedule, View receipt, Cancel session)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    _buildActionTile(
                      title: 'Reschedule',
                      onTap: () {
                        context.push(RouteNames.bookingDateTime);
                      },
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildActionTile(
                      title: 'View receipt',
                      onTap: () {},
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildActionTile(
                      title: 'Cancel session',
                      titleColor: AppColors.primary,
                      onTap: () {
                        CancelSessionBottomSheet.show(context, appt: appt);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Policy Footer
              Text(
                'Free to cancel or reschedule up to 24 hours before. Inside 24 hours the full fee applies.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: titleColor ?? AppColors.textPrimary,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
