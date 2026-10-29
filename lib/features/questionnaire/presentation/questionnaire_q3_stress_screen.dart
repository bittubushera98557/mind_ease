import 'package:flutter/material.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';

/// 1.09 Q3 Stress Screen – "How would you describe your stress lately?"
class QuestionnaireQ3StressScreen extends StatefulWidget {
  const QuestionnaireQ3StressScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireQ3StressScreen> createState() =>
      _QuestionnaireQ3StressScreenState();
}

class _QuestionnaireQ3StressScreenState
    extends State<QuestionnaireQ3StressScreen> {
  String? _selectedStress = 'High';

  static const List<_StressOption> _stressOptions = [
    _StressOption(label: 'Calm', icon: Icons.self_improvement_rounded),
    _StressOption(label: 'Manageable', icon: Icons.spa_rounded),
    _StressOption(label: 'Noticeable', icon: Icons.sentiment_neutral_rounded),
    _StressOption(label: 'High', icon: Icons.whatshot_rounded),
    _StressOption(label: 'Overwhelming', icon: Icons.warning_amber_rounded),
  ];

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
                  _buildStepIndicator(currentStep: 3, totalSteps: 4),
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
                'How would you describe your stress lately?',
                style: AppTypography.screenTitle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Select one option',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stress level options
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                itemCount: _stressOptions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final option = _stressOptions[index];
                  final isSelected = _selectedStress == option.label;
                  return _buildStressTile(
                    option: option,
                    isSelected: isSelected,
                    onTap: () =>
                        setState(() => _selectedStress = option.label),
                  );
                },
              ),
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
                    onPressed: _selectedStress != null
                        ? () {
                            Navigator.of(context).pushNamed(
                              RouteNames.questionnaireResults,
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      RouteNames.questionnaireResults,
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

  Widget _buildStressTile({
    required _StressOption option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySubtle : AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
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

class _StressOption {
  final String label;
  final IconData icon;

  const _StressOption({required this.label, required this.icon});
}
