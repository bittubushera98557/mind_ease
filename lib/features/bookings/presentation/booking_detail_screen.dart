import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/appointment_model.dart';

/// Detailed view screen for an appointment
class BookingDetailScreen extends StatelessWidget {
  final AppointmentModel? appointment;

  const BookingDetailScreen({
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
          focusAreas: ['Stress', 'Sleep'],
          totalAmount: 180.0,
          bookingRef: 'ME-BK-020125',
        );

    final isUpcoming = appt.status == AppointmentStatus.upcoming;

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
                        'APPOINTMENT DETAILS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'Therapy Session',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2EFE0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              appt.therapistInitials,
                              style: GoogleFonts.outfit(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF26682A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appt.therapistName,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                appt.therapistRole,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    const SizedBox(height: 16),

                    _buildDetailRow('Date', appt.dateString),
                    const SizedBox(height: 10),
                    _buildDetailRow('Time (AEDT)', appt.timeString),
                    const SizedBox(height: 10),
                    _buildDetailRow('Format', appt.format),
                    const SizedBox(height: 10),
                    _buildDetailRow('Focus areas',
                        appt.focusAreas.join(', ')),
                    const SizedBox(height: 10),
                    _buildDetailRow('Booking ref', appt.bookingRef),
                    const SizedBox(height: 10),
                    _buildDetailRow('Total paid',
                        '\$${appt.totalAmount.toStringAsFixed(2)} AUD'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (isUpcoming) ...[
                AppButton(
                  text: 'Join video call (Opens 10m before)',
                  onPressed: () {},
                    fontSize: 10,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Reschedule or cancel',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
