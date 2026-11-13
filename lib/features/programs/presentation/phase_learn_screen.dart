import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';

/// Phase Learn Screen dynamically displaying phase lessons
class PhaseLearnScreen extends StatelessWidget {
  final List<PhaseLessonModel>? lessons;
  final int phaseNumber;
  final String? programId;

  const PhaseLearnScreen({
    Key? key,
    this.lessons,
    this.phaseNumber = 1,
    this.programId,
  }) : super(key: key);

  static const List<_LessonData> _defaultLessons = [
    _LessonData(
      number: 1,
      duration: '4 min read',
      title: "Mental Health Isn't Just Mental",
      status: 'Not started',
    ),
    _LessonData(
      number: 2,
      duration: '5 min read',
      title: "Okay vs Not Okay \u2014 What's the Line?",
      status: 'Not started',
    ),
    _LessonData(
      number: 3,
      duration: '4 min read',
      title: 'What Shapes the Storm?',
      status: 'Not started',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hasDynamicLessons = lessons != null && lessons!.isNotEmpty;
    final totalLessons = hasDynamicLessons ? lessons!.length : _defaultLessons.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Back button & "PHASE X - LEARN" label
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'PHASE $phaseNumber - LEARN',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Learn',
                style: AppTypography.screenTitle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                '0 of $totalLessons lessons read. Open a lesson and mark it complete at the end.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Lesson Cards
              if (hasDynamicLessons)
                ...List.generate(lessons!.length, (index) {
                  final lesson = lessons![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildDynamicLessonCard(
                      context,
                      lesson,
                      index + 1,
                      lessons!.length,
                    ),
                  );
                })
              else
                ..._defaultLessons.map(
                  (lesson) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLessonCard(context, lesson),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicLessonCard(
    BuildContext context,
    PhaseLessonModel lesson,
    int lessonNumber,
    int totalLessons,
  ) {
    final durationStr = lesson.minutes > 0 ? '${lesson.minutes} min read' : '4 min read';
    return GestureDetector(
      onTap: () => context.push(
        RouteNames.lessonDetail,
        extra: {
          'lesson': lesson,
          'lessonNumber': lessonNumber,
          'totalLessons': totalLessons,
          'programId': programId,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio / Checkbox circle
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: lesson.isRead ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: lesson.isRead ? AppColors.primary : AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
              child: lesson.isRead
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson $lessonNumber \u00b7 $durationStr',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.isRead ? 'Completed' : 'Not started',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: lesson.isRead ? const Color(0xFF4C7B3B) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Chevron arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, _LessonData lesson) {
    return GestureDetector(
      onTap: () => context.push(
        RouteNames.lessonDetail,
        extra: {
          'lessonNumber': lesson.number,
          'totalLessons': 3,
          'programId': programId,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio / Checkbox circle
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder, width: 1.5),
              ),
            ),
            const SizedBox(width: 16),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson ${lesson.number} \u00b7 ${lesson.duration}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.status,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Chevron arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonData {
  final int number;
  final String duration;
  final String title;
  final String status;

  const _LessonData({
    required this.number,
    required this.duration,
    required this.title,
    required this.status,
  });
}
