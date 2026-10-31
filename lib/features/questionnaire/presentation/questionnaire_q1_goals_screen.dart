import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';

/// 1.07 Q1 Goals Screen – "What would you like MindEase to help with?"
class QuestionnaireQ1GoalsScreen extends StatefulWidget {
  const QuestionnaireQ1GoalsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireQ1GoalsScreen> createState() =>
      _QuestionnaireQ1GoalsScreenState();
}

class _QuestionnaireQ1GoalsScreenState
    extends State<QuestionnaireQ1GoalsScreen> {
  final Set<String> _selectedGoals = {'Support someone I care about'};

  static const List<String> _goals = [
    'Understand my mental health',
    'Manage stress',
    'Notice my emotions',
    'Talk about how I feel',
    'Support someone I care about',
    'Build healthier habits',
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
                  _buildStepIndicator(currentStep: 1, totalSteps: 4),
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
                'What would you like MindEase to help with?',
                style: AppTypography.screenTitle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Choose all that apply',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Options list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                itemCount: _goals.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = _selectedGoals.contains(goal);
                  return _buildOptionTile(
                    label: goal,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selectedGoals.remove(goal);
                      } else {
                        _selectedGoals.add(goal);
                      }
                    }),
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
                    onPressed: _selectedGoals.isNotEmpty
                        ? () {
                            context.push(RouteNames.questionnaireQ2Mood);
                          }
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => context.push(RouteNames.questionnaireQ2Mood),
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

  Widget _buildOptionTile({
    required String label,
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
                  label,
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 14.5,
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
