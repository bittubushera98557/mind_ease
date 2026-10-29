import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

/// 1.11 Next Steps Screen – "Your Next Steps"
class QuestionnaireNextStepsScreen extends StatelessWidget {
  const QuestionnaireNextStepsScreen({Key? key}) : super(key: key);

  static const List<_NextStep> _steps = [
    _NextStep(
      number: 1,
      title: 'Setup Profile & Assessment',
      subtitle: "You've set up your profile and answered the questionnaire",
      isCompleted: true,
    ),
    _NextStep(
      number: 2,
      title: 'Receive Personalised Suggestions',
      subtitle: 'Your personalised program is ready to explore',
      isCompleted: false,
      isCurrent: true,
    ),
    _NextStep(
      number: 3,
      title: 'Start Your First Program',
      subtitle: "Begin with the Self-Reflection Program",
      isCompleted: false,
    ),
    _NextStep(
      number: 4,
      title: 'Schedule Therapy Appointment',
      subtitle: 'Book a therapist when you\'re ready. Coming soon.',
      isCompleted: false,
      isDisabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top close/back button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Header text
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Your Next Steps',
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "You're all set up. Here's what comes next:",
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // Steps timeline
                    ..._buildStepsTimeline(),

                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: AppButton(
                text: "OK, let's get started",
                onPressed: () {
                  // Navigate to home / program listing
                  // For now navigate back to root
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
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
      widgets.add(_buildTimelineStep(step: step, isLast: isLast));
    }
    return widgets;
  }

  Widget _buildTimelineStep({
    required _NextStep step,
    required bool isLast,
  }) {
    Color circleColor;
    Color borderColor;
    Widget circleChild;

    if (step.isCompleted) {
      circleColor = AppColors.alertSuccessBg;
      borderColor = AppColors.alertSuccessIcon;
      circleChild = const Icon(
        Icons.check_rounded,
        size: 18,
        color: AppColors.alertSuccessIcon,
      );
    } else if (step.isCurrent) {
      circleColor = AppColors.primarySubtle;
      borderColor = AppColors.primary;
      circleChild = Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      );
    } else {
      circleColor = AppColors.surfaceMuted;
      borderColor = AppColors.inputBorder;
      circleChild = Text(
        '${step.number}',
        style: AppTypography.inputLabel.copyWith(
          fontSize: 12,
          color: step.isDisabled
              ? AppColors.textTertiary
              : AppColors.textSecondary,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Column(
            children: [
              // Circle indicator
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Center(child: circleChild),
              ),
              // Connector line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),

          // Step content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.xl,
                top: 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTypography.inputLabel.copyWith(
                      fontSize: 14.5,
                      color: step.isDisabled
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    step.subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12.5,
                      color: step.isDisabled
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (step.isCurrent) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: AppSpacing.roundedPill,
                      ),
                      child: Text(
                        'Up next',
                        style: AppTypography.bannerText.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  if (step.isDisabled) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: AppSpacing.roundedPill,
                      ),
                      child: Text(
                        'Coming soon',
                        style: AppTypography.bannerText.copyWith(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStep {
  final int number;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isDisabled;

  const _NextStep({
    required this.number,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isDisabled = false,
  });
}
