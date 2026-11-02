import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../data/models/appointment_model.dart';

/// 5.11 Session Ended / Post-Session Feedback Screen
class BookingSessionEndedScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const BookingSessionEndedScreen({
    Key? key,
    this.appointment,
  }) : super(key: key);

  @override
  State<BookingSessionEndedScreen> createState() =>
      _BookingSessionEndedScreenState();
}

class _BookingSessionEndedScreenState extends State<BookingSessionEndedScreen> {
  int _selectedMoodIndex = 2; // Default "A bit better"

  final List<Map<String, String>> _moods = const [
    {'label': 'Worse'},
    {'label': 'Same'},
    {'label': 'A bit\nbetter'},
    {'label': 'Better'},
    {'label': 'Much\nbetter'},
  ];

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment ??
        const AppointmentModel(
          id: 'bk-01',
          therapistName: 'Dr Priya Nair',
          therapistRole: 'Clinical Psychologist',
          therapistInitials: 'PN',
          dateString: 'Wed 18 Nov',
          dateBadge: 'NOV 18',
          timeString: '10:00 - 10:50 am',
          duration: '50 min',
          format: 'Video',
          status: AppointmentStatus.completed,
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
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Avatar Circle
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5F2D6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    appt.therapistInitials,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4A6B34),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                'Session ended',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                '${appt.therapistName} · ${appt.duration}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 20),

              // Card 1: How are you feeling now?
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0ECE6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling now?',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 5 Mood Pill Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_moods.length, (index) {
                        final isSelected = _selectedMoodIndex == index;
                        final mood = _moods[index];

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMoodIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index < _moods.length - 1 ? 5 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF3E3125)
                                      : const Color(0xFFEBE6DF),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _MoodFaceIcon(
                                    index: index,
                                    isSelected: isSelected,
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 24,
                                    child: Center(
                                      child: Text(
                                        mood['label']!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9.5,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          color: isSelected
                                              ? const Color(0xFF3E3125)
                                              : AppColors.textSecondary,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Private to you. Helps track your progress over time.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF4EFEA),
                    ),
                    const SizedBox(height: 12),

                    // Any problems with the call? Report
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Any problems with the call?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Report',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Card 2: Next Session Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0ECE6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Date Badge box
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCEBE8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NOV',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD94A38),
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '18',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD94A38),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next session',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Wed 18 Nov · 10:00 am',
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
              ),
              const SizedBox(height: 14),

              // Card 3: Support Banner
              InkWell(
                onTap: () {
                  context.push(RouteNames.supportOptions);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3E2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: Color(0xFF2C5220),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Feeling unsafe after the session? Get help now',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2C5220),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: Color(0xFF2C5220),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Book a follow-up button
              AppButton(
                text: 'Book a follow-up',
                backgroundColor: const Color(0xFFD94A38),
                onPressed: () {
                  context.push(RouteNames.bookingFocus);
                },
              ),
              const SizedBox(height: 12),

              // Back to home button
              OutlinedButton(
                onPressed: () {
                  context.go(RouteNames.dashboard);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Color(0xFFE2DBD0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Back to home',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _MoodFaceIcon extends StatelessWidget {
  final int index;
  final bool isSelected;

  const _MoodFaceIcon({
    Key? key,
    required this.index,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;

    switch (index) {
      case 0: // Worse
        bgColor = const Color(0xFFFDE8E5);
        iconColor = const Color(0xFFD9534F);
        break;
      case 1: // Same
        bgColor = const Color(0xFFFDF3E3);
        iconColor = const Color(0xFFD99B38);
        break;
      case 2: // A bit better
        bgColor = const Color(0xFFEAF5E5);
        iconColor = const Color(0xFF4A7C38);
        break;
      case 3: // Better
        bgColor = const Color(0xFFE2F0DC);
        iconColor = const Color(0xFF386629);
        break;
      case 4: // Much better
      default:
        bgColor = const Color(0xFF88AF70);
        iconColor = Colors.white;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(18, 18),
          painter: _MoodFacePainter(index: index, color: iconColor),
        ),
      ),
    );
  }
}

class _MoodFacePainter extends CustomPainter {
  final int index;
  final Color color;

  _MoodFacePainter({required this.index, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final eyeY = size.height * 0.38;
    final leftEyeX = size.width * 0.32;
    final rightEyeX = size.width * 0.68;
    const eyeRadius = 1.1;

    canvas.drawCircle(Offset(leftEyeX, eyeY), eyeRadius, fillPaint);
    canvas.drawCircle(Offset(rightEyeX, eyeY), eyeRadius, fillPaint);

    final path = Path();
    final mouthY = size.height * 0.68;
    final mouthWidth = size.width * 0.44;
    final startX = (size.width - mouthWidth) / 2;
    final endX = startX + mouthWidth;

    if (index == 0) {
      path.moveTo(startX, mouthY + 2);
      path.quadraticBezierTo(size.width / 2, mouthY - 3, endX, mouthY + 2);
    } else if (index == 1) {
      path.moveTo(startX, mouthY);
      path.lineTo(endX, mouthY);
    } else if (index == 2) {
      path.moveTo(startX, mouthY - 1);
      path.quadraticBezierTo(size.width / 2, mouthY + 2.5, endX, mouthY - 1);
    } else if (index == 3) {
      path.moveTo(startX - 1, mouthY - 1.5);
      path.quadraticBezierTo(size.width / 2, mouthY + 3.5, endX + 1, mouthY - 1.5);
    } else {
      path.moveTo(startX - 1, mouthY - 1.5);
      path.quadraticBezierTo(size.width / 2, mouthY + 4, endX + 1, mouthY - 1.5);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MoodFacePainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.color != color;
  }
}
