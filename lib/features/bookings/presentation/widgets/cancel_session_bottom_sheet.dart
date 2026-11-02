import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/appointment_model.dart';

/// 5.08 Cancel / Reschedule Session Bottom Sheet Modal
class CancelSessionBottomSheet extends StatelessWidget {
  final AppointmentModel? appt;

  const CancelSessionBottomSheet({
    Key? key,
    this.appt,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {AppointmentModel? appt}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelSessionBottomSheet(appt: appt),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = appt ??
        const AppointmentModel(
          id: 'bk-01',
          therapistName: 'Dr Priya Nair',
          therapistRole: 'Clinical Psychologist',
          therapistInitials: 'PN',
          dateString: 'Wed 4 Nov',
          dateBadge: 'NOV 4',
          timeString: '10:00 am video',
          duration: '30 min',
          format: 'Video',
          status: AppointmentStatus.upcoming,
          totalAmount: 180.0,
          bookingRef: 'ME-BK-020125',
        );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E2DA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Cancel this session?',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Session Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2EFE0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      session.therapistInitials,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
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
                        session.therapistName,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${session.dateString} • ${session.timeString}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Policy Card (Green box)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7EE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBCE3C4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: Color(0xFF236539),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "More than 24 hours away. You'll get a full refund to Apple Pay in 5 - 10 business days.",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF236539),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Inside 24 hours this box turns amber: "The full fee applies. Reschedule now for 10% fee."',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppColors.textTertiary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(RouteNames.bookingDateTime);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppColors.inputBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Reschedule instead',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),

          AppButton(
            text: 'Cancel session',
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.dashboard, extra: 2);
            },
          ),
          const SizedBox(height: 8),

          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Keep session',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
