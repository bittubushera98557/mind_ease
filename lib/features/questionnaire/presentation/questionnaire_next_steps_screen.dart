import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

/// 1.11 Next Steps Screen – "Your Next Steps"
class QuestionnaireNextStepsScreen extends StatelessWidget {
  const QuestionnaireNextStepsScreen({Key? key}) : super(key: key);

  static const List<_NextStepData> _steps = [
    _NextStepData(
      title: 'Setup Profile & Assessment',
      subtitle: "You've set up your profile and answered the questionnaire.",
      icon: Icons.check_rounded,
      type: _StepType.completed,
    ),
    _NextStepData(
      title: 'Receive Personalised Suggestions',
      subtitle: 'Your recommended phases are ready in My Programs.',
      icon: Icons.auto_awesome_rounded,
      type: _StepType.activeSparkle,
    ),
    _NextStepData(
      title: 'Start Your First Program',
      subtitle: 'Begin Phase 1 of the Self-Reflection Program.',
      icon: Icons.menu_book_rounded,
      type: _StepType.highlighted,
    ),
    _NextStepData(
      title: 'Schedule Therapy Appointment',
      subtitle: "Book a therapist when you're ready. Coming soon.",
      icon: Icons.calendar_today_rounded,
      type: _StepType.disabled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),

                    // Header title
                    Text(
                      'Your Next Steps',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Header subtitle
                    Text(
                      "You're all set up. Here's what comes next.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Steps timeline
                    ..._buildStepsTimeline(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: AppButton(
                text: "OK, let's get started",
                icon: Icons.home_outlined,
                onPressed: () {
                  context.go(RouteNames.dashboard);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStepsTimeline() {
    final widgets = <Widget>[];
    for (int i = 0; i < _steps.length; i++) {
      final step = _steps[i];
      final isLast = i == _steps.length - 1;

      // Determine connector line color below step
      Color lineColor = AppColors.primary;
      if (step.type == _StepType.highlighted || step.type == _StepType.disabled) {
        lineColor = const Color(0xFFE8E1D9);
      }

      widgets.add(
        _buildTimelineStep(
          step: step,
          isLast: isLast,
          lineColor: lineColor,
        ),
      );
    }
    return widgets;
  }

  Widget _buildTimelineStep({
    required _NextStepData step,
    required bool isLast,
    required Color lineColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 54,
            child: Column(
              children: [
                _buildStepIndicator(step),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Content text column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 26.0,
                top: step.type == _StepType.highlighted ? 12.0 : 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(_NextStepData step) {
    switch (step.type) {
      case _StepType.completed:
        return Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 20,
            color: Colors.white,
          ),
        );

      case _StepType.activeSparkle:
        return Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 19,
            color: Colors.white,
          ),
        );

      case _StepType.highlighted:
        return Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Color(0xFFF7ECE5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.icon,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        );

      case _StepType.disabled:
        return Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFECE5DF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 18,
            color: const Color(0xFF8E847C),
          ),
        );
    }
  }
}

enum _StepType {
  completed,
  activeSparkle,
  highlighted,
  disabled,
}

class _NextStepData {
  final String title;
  final String subtitle;
  final IconData icon;
  final _StepType type;

  const _NextStepData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
  });
}
