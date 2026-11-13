import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/assessment_response_model.dart';
import '../data/models/onboarding_questionnaire_model.dart';
import 'providers/questionnaire_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════════

/// Whether a question accepts one answer or many.
enum QuestionType { single, multi }

/// A single selectable option inside a question.
class QuestionOption {
  final String label;

  /// Optional secondary text shown below the label (e.g. "Lessons first").
  final String? subtitle;

  /// When [isExclusive] is true, selecting this option deselects all others.
  final bool isExclusive;

  const QuestionOption({
    required this.label,
    this.subtitle,
    this.isExclusive = false,
  });
}

/// A single question in the assessment.
class QuizQuestion {
  final String title;

  /// Coral hint shown below the title for multi-select questions.
  final String? chooseHint;

  final QuestionType type;
  final List<QuestionOption> options;

  const QuizQuestion({
    required this.title,
    this.chooseHint,
    required this.type,
    required this.options,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// FALLBACK QUESTION BANK
// ═══════════════════════════════════════════════════════════════════════════════

const List<QuizQuestion> kAssessmentQuestions = [
  QuizQuestion(
    title: 'What would you like MindEase to help with?',
    chooseHint: 'Choose all that apply.',
    type: QuestionType.multi,
    options: [
      QuestionOption(label: 'Understand my mental health'),
      QuestionOption(label: 'Manage stress'),
      QuestionOption(label: 'Notice my emotions'),
      QuestionOption(label: 'Talk about how I feel'),
      QuestionOption(label: 'Support someone I care about'),
      QuestionOption(label: 'Build healthier habits'),
    ],
  ),
  QuizQuestion(
    title: 'Over the past two weeks, how have you been feeling overall?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: 'Really good'),
      QuestionOption(label: 'Good'),
      QuestionOption(label: 'Okay'),
      QuestionOption(label: 'Low'),
      QuestionOption(label: 'Very low'),
    ],
  ),
  QuizQuestion(
    title: 'How would you describe your stress lately?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: 'Calm'),
      QuestionOption(label: 'Manageable'),
      QuestionOption(label: 'Noticeable'),
      QuestionOption(label: 'High'),
      QuestionOption(label: 'Overwhelming'),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

/// 1.07 – 1.09 Questionnaire Survey Screen dynamically bound to /questionnaires/onboarding
class QuestionnaireSurveyScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const QuestionnaireSurveyScreen({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  ConsumerState<QuestionnaireSurveyScreen> createState() =>
      _QuestionnaireSurveyScreenState();
}

class _QuestionnaireSurveyScreenState
    extends ConsumerState<QuestionnaireSurveyScreen> {
  late int _currentIndex;
  bool _isSubmitting = false;

  /// Stores the selected answer labels per question index.
  final Map<int, Set<String>> _answers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  List<QuizQuestion> _parseQuestions(OnboardingQuestionnaireModel model) {
    if (model.questions.isEmpty) return kAssessmentQuestions;

    return model.questions.map((q) {
      final isMulti = q.type == 'multi';
      return QuizQuestion(
        title: q.q,
        chooseHint: isMulti ? 'Choose all that apply.' : null,
        type: isMulti ? QuestionType.multi : QuestionType.single,
        options: q.options.map((opt) {
          final isExclusive = q.exclusive != null &&
              (opt.v == q.exclusive || opt.label == q.exclusive);
          return QuestionOption(
            label: opt.label,
            isExclusive: isExclusive,
          );
        }).toList(),
      );
    }).toList();
  }

  void _handleBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _handleOptionTap(QuizQuestion q, String label) {
    final option = q.options.firstWhere((o) => o.label == label);

    setState(() {
      if (q.type == QuestionType.single) {
        _answers[_currentIndex] = {label};
      } else {
        final current = Set<String>.from(_answers[_currentIndex] ?? {});
        if (current.contains(label)) {
          current.remove(label);
        } else {
          if (option.isExclusive) {
            current
              ..clear()
              ..add(label);
          } else {
            final exclusives =
                q.options.where((o) => o.isExclusive).map((o) => o.label).toSet();
            current
              ..removeAll(exclusives)
              ..add(label);
          }
        }
        _answers[_currentIndex] = current;
      }
    });
  }

  Future<void> _advance(int totalQuestions, String? version) async {
    if (_isSubmitting) return;

    final isLast = _currentIndex >= totalQuestions - 1;
    final currentAnswers = (_answers[_currentIndex] ?? {}).toList();

    setState(() {
      _isSubmitting = true;
    });

    AssessmentResponseModel? response;
    try {
      final repository = ref.read(questionnaireRepositoryProvider);
      response = await repository.submitAssessmentStep(
        answers: currentAnswers,
        step: _currentIndex,
        completedAt: isLast ? DateTime.now().toUtc().toIso8601String() : null,
        nextStepsSeen: isLast,
        questionnaireVersion: version,
      );
      if (isLast && response.isSuccess) {
        ref.read(lastAssessmentResponseProvider.notifier).state = response;
      }
    } catch (e) {
      debugPrint('Error submitting assessment step: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (isLast) {
          context.push(RouteNames.questionnaireResults, extra: response);
        } else {
          setState(() {
            _currentIndex++;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionnaireAsync = ref.watch(onboardingQuestionnaireProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: questionnaireAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => _buildErrorState(err.toString()),
          data: (model) {
            if (!model.isSuccess) {
              return _buildErrorState(
                model.error?.message ?? 'Failed to load questionnaire',
              );
            }

            final questions = _parseQuestions(model);
            if (_currentIndex >= questions.length) {
              _currentIndex = questions.length - 1;
            }
            if (_currentIndex < 0) _currentIndex = 0;

            final currentQ = questions[_currentIndex];
            final currentAnswers = _answers[_currentIndex] ?? {};
            final hasAnswer = currentAnswers.isNotEmpty;
            final isLast = _currentIndex == questions.length - 1;
            final total = questions.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                _TopBar(
                  onBack: _handleBack,
                  currentStep: _currentIndex + 1,
                  totalSteps: total,
                ),

                // Progress bar
                _AssessmentProgressBar(
                  current: _currentIndex + 1,
                  total: total,
                ),

                // Scrollable question + options
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.03, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: _QuestionBody(
                      key: ValueKey(_currentIndex),
                      question: currentQ,
                      selectedAnswers: currentAnswers,
                      onOptionTap: (label) => _handleOptionTap(currentQ, label),
                    ),
                  ),
                ),

                // Bottom actions
                _BottomActions(
                  hasAnswer: hasAnswer,
                  isLast: isLast,
                  isLoading: _isSubmitting,
                  onContinue: () => _advance(total, model.version),
                  onSkip: () => _advance(total, model.version),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.alertErrorIcon,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(onboardingQuestionnaireProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPOSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const _TopBar({
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Row(
        children: [
          CircularBackButton(onPressed: onBack),
          Expanded(
            child: Center(
              child: Text(
                'ASSESSMENT',
                style: AppTypography.inputLabel.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          Text(
            '$currentStep of $totalSteps',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssessmentProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _AssessmentProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillWidth = (current / total) * constraints.maxWidth;
          return Stack(
            children: [
              Container(
                height: 3,
                width: constraints.maxWidth,
                color: AppColors.inputBorder,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOut,
                height: 3,
                width: fillWidth,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  final QuizQuestion question;
  final Set<String> selectedAnswers;
  final ValueChanged<String> onOptionTap;

  const _QuestionBody({
    super.key,
    required this.question,
    required this.selectedAnswers,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      children: [
        Text(
          question.title,
          style: AppTypography.screenTitle.copyWith(fontSize: 22),
        ),
        if (question.chooseHint != null) ...[
          const SizedBox(height: 5),
          Text(
            question.chooseHint!,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.primary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        ...question.options.map((option) {
          final isSelected = selectedAnswers.contains(option.label);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _OptionCard(
              option: option,
              isSelected: isSelected,
              questionType: question.type,
              onTap: () => onOptionTap(option.label),
            ),
          );
        }),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final QuestionOption option;
  final bool isSelected;
  final QuestionType questionType;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.questionType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.04)
            : AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.04 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.roundedMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedMd,
          splashColor: AppColors.primary.withOpacity(0.06),
          highlightColor: AppColors.primary.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: AppTypography.inputLabel.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 12.5,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SelectionIndicator(
                  isSelected: isSelected,
                  isRadio: questionType == QuestionType.single,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isRadio;

  const _SelectionIndicator({
    required this.isSelected,
    required this.isRadio,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        shape: isRadio ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isRadio
            ? null
            : const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: isSelected ? 0 : 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _BottomActions extends StatelessWidget {
  final bool hasAnswer;
  final bool isLast;
  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const _BottomActions({
    required this.hasAnswer,
    required this.isLast,
    this.isLoading = false,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          AppButton(
            text: isLast ? 'See my suggestions' : 'Continue',
            onPressed: hasAnswer && !isLoading ? onContinue : null,
            isLoading: isLoading,
            backgroundColor:
                hasAnswer ? AppColors.primary : const Color(0xFFD0CBC6),
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: isLoading ? null : onSkip,
            child: Text(
              'Skip this question',
              style: AppTypography.linkText.copyWith(
                fontSize: 13,
                color: AppColors.accentTeal,
                decorationColor: AppColors.accentTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
