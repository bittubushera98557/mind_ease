import 'package:flutter/material.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../../../core/widgets/mood_emojis.dart';

/// 1.08 Q2 Mood Screen – "Over the past two weeks, how have you been feeling overall?"
class QuestionnaireQ2MoodScreen extends StatefulWidget {
  const QuestionnaireQ2MoodScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireQ2MoodScreen> createState() =>
      _QuestionnaireQ2MoodScreenState();
}

class _QuestionnaireQ2MoodScreenState
    extends State<QuestionnaireQ2MoodScreen> {
  String? _selectedMood;
  bool _showSupportBanner = false;

  static const List<_MoodOption> _moodOptions = [
    _MoodOption(
      label: 'Really good',
      emoji: MoodType.happy,
      color: AppColors.moodHappy,
    ),
    _MoodOption(
      label: 'Good',
      emoji: MoodType.calm,
      color: AppColors.moodCalm,
    ),
    _MoodOption(
      label: 'Okay',
      emoji: MoodType.neutral,
      color: AppColors.moodNeutral,
    ),
    _MoodOption(
      label: 'Low',
      emoji: MoodType.sad,
      color: AppColors.moodSad,
    ),
    _MoodOption(
      label: 'Very low',
      emoji: MoodType.worried,
      color: AppColors.moodWorried,
    ),
  ];

  void _selectMood(String label) {
    setState(() {
      _selectedMood = label;
      _showSupportBanner =
          label == 'Very low' || label == 'Low';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  CircularBackButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  _buildStepIndicator(currentStep: 2, totalSteps: 4),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Assessment label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'ASSESSMENT',
                style: AppTypography.inputLabel.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Question
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Over the past two weeks, how have you been feeling overall?',
                style: AppTypography.screenTitle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Go with your first instinct',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Mood options
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                itemCount: _moodOptions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final option = _moodOptions[index];
                  final isSelected = _selectedMood == option.label;
                  return _buildMoodTile(
                    option: option,
                    isSelected: isSelected,
                    onTap: () => _selectMood(option.label),
                  );
                },
              ),
            ),

            // Support banner (animated)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _showSupportBanner
                  ? _buildSupportBanner()
                  : const SizedBox.shrink(),
            ),

            // Bottom continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  AppButton(
                    text: 'Continue',
                    onPressed: _selectedMood != null
                        ? () {
                            Navigator.of(context).pushNamed(
                              RouteNames.questionnaireQ3Stress,
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      RouteNames.questionnaireQ3Stress,
                    ),
                    child: Text(
                      'Skip this question',
                      style: AppTypography.footerRegular.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTile({
    required _MoodOption option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? option.color.withOpacity(0.12)
            : AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(
          color: isSelected ? option.color : AppColors.inputBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 13,
          ),
          child: Row(
            children: [
              // Emoji face circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: option.color,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  size: const Size(32, 32),
                  painter: _FacePainter(mood: option.emoji),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  option.label,
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? option.color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? option.color : AppColors.inputBorder,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportBanner() {
    return Container(
      key: const ValueKey('support_banner'),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.alertErrorBg,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.alertErrorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thanks for telling us',
            style: AppTypography.inputLabel.copyWith(
              color: AppColors.alertErrorText,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "That sounds tough. If you need to talk to someone now, help is available 24/7.",
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.alertErrorText,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.headset_mic_rounded,
                  size: 14,
                  color: AppColors.alertErrorText,
                ),
                const SizedBox(width: 5),
                Text(
                  'See support options',
                  style: AppTypography.linkText.copyWith(
                    color: AppColors.alertErrorText,
                    decorationColor: AppColors.alertErrorText,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int currentStep,
    required int totalSteps,
  }) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Container(
          margin: const EdgeInsets.only(left: 5),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.inputBorder,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _MoodOption {
  final String label;
  final MoodType emoji;
  final Color color;

  const _MoodOption({
    required this.label,
    required this.emoji,
    required this.color,
  });
}

/// Inline face painter reusing mood drawing logic
class _FacePainter extends CustomPainter {
  final MoodType mood;

  const _FacePainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = const Color(0xFF261D1A).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final mouthPaint = Paint()
      ..color = const Color(0xFF261D1A).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.058
      ..strokeCap = StrokeCap.round;

    final eyeRadius = size.width * 0.055;
    final eyeY = size.height * 0.38;
    final leftEyeX = size.width * 0.33;
    final rightEyeX = size.width * 0.67;

    canvas.drawCircle(Offset(leftEyeX, eyeY), eyeRadius, eyePaint);
    canvas.drawCircle(Offset(rightEyeX, eyeY), eyeRadius, eyePaint);

    final mouthY = size.height * 0.66;
    final mouthWidth = size.width * 0.36;
    final mouthLeft = (size.width - mouthWidth) / 2;
    final mouthRight = mouthLeft + mouthWidth;

    switch (mood) {
      case MoodType.happy:
        final path = Path();
        path.moveTo(mouthLeft, mouthY - 1);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.18),
          mouthRight,
          mouthY - 1,
        );
        canvas.drawPath(path, mouthPaint);
        break;
      case MoodType.calm:
        final path = Path();
        path.moveTo(mouthLeft, mouthY);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY + (size.height * 0.1),
          mouthRight,
          mouthY,
        );
        canvas.drawPath(path, mouthPaint);
        break;
      case MoodType.neutral:
        canvas.drawLine(
          Offset(mouthLeft, mouthY + 2),
          Offset(mouthRight, mouthY + 2),
          mouthPaint,
        );
        break;
      case MoodType.sad:
        final path = Path();
        path.moveTo(mouthLeft, mouthY + 4);
        path.quadraticBezierTo(
          size.width / 2,
          mouthY - (size.height * 0.1),
          mouthRight,
          mouthY + 4,
        );
        canvas.drawPath(path, mouthPaint);
        break;
      case MoodType.worried:
        final path = Path();
        final seg = mouthWidth / 4;
        path.moveTo(mouthLeft, mouthY + 2);
        path.quadraticBezierTo(
          mouthLeft + seg,
          mouthY - 3,
          mouthLeft + (seg * 2),
          mouthY + 2,
        );
        path.quadraticBezierTo(
          mouthLeft + (seg * 3),
          mouthY + 6,
          mouthRight,
          mouthY + 1,
        );
        canvas.drawPath(path, mouthPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FacePainter old) => old.mood != mood;
}
