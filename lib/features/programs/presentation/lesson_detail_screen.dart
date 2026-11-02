import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';

/// Lesson Detail Screen dynamically rendering lesson content
class LessonDetailScreen extends StatelessWidget {
  final PhaseLessonModel? lesson;
  final int lessonNumber;
  final int totalLessons;
  final String lessonTitle;
  final String duration;

  const LessonDetailScreen({
    Key? key,
    this.lesson,
    this.lessonNumber = 1,
    this.totalLessons = 3,
    this.lessonTitle = "Mental Health Isn't Just Mental",
    this.duration = "4 min read",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = lesson?.title.isNotEmpty == true
        ? lesson!.title
        : lessonTitle;
    final effectiveDuration = lesson?.minutes != null && lesson!.minutes > 0
        ? '${lesson!.minutes} min read'
        : duration;
    final introText = lesson?.intro ??
        'Mental health is how we think, feel and act. It affects how we handle stress, connect with people and make choices. And it doesn\'t stay in your head.';

    final hasSections = lesson?.sections != null && lesson!.sections.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top progress bar
            LinearProgressIndicator(
              value: totalLessons > 0 ? (lessonNumber / totalLessons) : 0.33,
              minHeight: 3,
              backgroundColor: const Color(0xFFE8E2DA),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'LESSON $lessonNumber OF $totalLessons',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable article content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration tag
                    Row(
                      children: [
                        Text(
                          effectiveDuration,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      effectiveTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Intro paragraph
                    Text(
                      introText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamic Sections or Fallback
                    if (hasSections) ...[
                      ...lesson!.sections.map((section) => _buildSection(section)),
                    ] else ...[
                      Text(
                        'It shows up in three places',
                        style: GoogleFonts.outfit(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "When your mental health shifts, you'll usually notice it somewhere first:",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _bulletPoint("Your body: sleep, energy, appetite, tension, headaches"),
                      const SizedBox(height: 10),
                      _bulletPoint("Your thoughts: focus, worry, the way you talk to yourself"),
                      const SizedBox(height: 10),
                      _bulletPoint("Your habits: how you spend time, who you see, how you switch off"),
                    ],

                    const SizedBox(height: 24),

                    // Real-World Example Card
                    if (lesson?.example != null && lesson!.example!.isNotEmpty)
                      _buildExampleCard(lesson!.example!)
                    else
                      _buildExampleCard(
                        "During a busy month at work, Sam sleeps badly, skips the gym and snaps at his housemate. None of that makes him a bad person. It's his mental health showing up in his body and habits.",
                      ),
                    const SizedBox(height: 16),

                    // Key Takeaway Card
                    if (lesson?.takeaway != null && lesson!.takeaway!.isNotEmpty)
                      _buildTakeawayCard(lesson!.takeaway!)
                    else
                      _buildTakeawayCard(
                        "Mental health is part of your overall health. Noticing it in your body and habits is the first skill.",
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.inputBorder, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: "✓ I've read this lesson",
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(PhaseLessonSectionModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.h != null && section.h!.isNotEmpty) ...[
          Text(
            section.h!,
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        ...section.p.map(
          (para) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              para,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        if (section.list.isNotEmpty) const SizedBox(height: 6),
        ...section.list.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _bulletPoint(item),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExampleCard(String exampleText) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REAL-WORLD EXAMPLE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exampleText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeawayCard(String takeawayText) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3525),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY TAKEAWAY',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            takeawayText,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
