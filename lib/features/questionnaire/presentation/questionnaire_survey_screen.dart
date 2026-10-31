import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';

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

  /// When [isExclusive] is true, selecting this option deselects all others
  /// (e.g. "None of these", "No one right now").
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
  /// Leave null for single-select to hide it.
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
// QUESTION BANK  ← Edit here to add / remove / reorder questions
// ═══════════════════════════════════════════════════════════════════════════════

const List<QuizQuestion> kAssessmentQuestions = [
  // Q1 ─ Goals (multi-select)
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

  // Q2 ─ Overall mood (single-select)
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

  // Q3 ─ Stress level (single-select)
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

  // Q4 ─ Sleep (single-select)
  QuizQuestion(
    title: 'How has your sleep been?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: 'Restful'),
      QuestionOption(label: 'Mostly fine'),
      QuestionOption(label: 'Patchy'),
      QuestionOption(label: 'Poor'),
    ],
  ),

  // Q5 ─ Physical stress symptoms (multi-select)
  QuizQuestion(
    title: 'Have you noticed stress showing up in your body?',
    chooseHint: 'Choose any that apply.',
    type: QuestionType.multi,
    options: [
      QuestionOption(label: 'Headaches'),
      QuestionOption(label: 'Muscle tension'),
      QuestionOption(label: 'Tiredness'),
      QuestionOption(label: 'Appetite changes'),
      QuestionOption(label: 'Racing heart'),
      QuestionOption(label: 'None of these', isExclusive: true),
    ],
  ),

  // Q6 ─ Talking about feelings (single-select)
  QuizQuestion(
    title: 'How easy is it for you to talk about how you feel?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: 'Easy'),
      QuestionOption(label: 'Sometimes easy'),
      QuestionOption(label: 'Hard'),
      QuestionOption(label: 'Very hard'),
    ],
  ),

  // Q7 ─ Support network (multi-select)
  QuizQuestion(
    title: 'Who could you reach out to if things got tough?',
    chooseHint: 'Choose any that apply.',
    type: QuestionType.multi,
    options: [
      QuestionOption(label: 'Family'),
      QuestionOption(label: 'Friends'),
      QuestionOption(label: 'Partner'),
      QuestionOption(label: 'A health professional'),
      QuestionOption(label: 'Community or faith group'),
      QuestionOption(label: 'No one right now', isExclusive: true),
    ],
  ),

  // Q8 ─ Learning style (single-select, options have subtitles)
  QuizQuestion(
    title: 'How do you like to learn?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: 'Short reads', subtitle: 'Lessons first'),
      QuestionOption(label: 'Short videos', subtitle: 'Videos first'),
      QuestionOption(label: 'Hands-on activities', subtitle: 'Reflection first'),
      QuestionOption(label: 'A mix of everything'),
    ],
  ),

  // Q9 — Daily time commitment (single-select, last question)
  QuizQuestion(
    title: 'How much time can you give each day?',
    type: QuestionType.single,
    options: [
      QuestionOption(label: '5 minutes'),
      QuestionOption(label: '10 minutes'),
      QuestionOption(label: '15 minutes'),
      QuestionOption(label: '20 minutes or more'),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

/// 1.07 – 1.09  Questionnaire Survey Screen
/// Data-driven single screen that handles all [kAssessmentQuestions].
/// Navigate here once from [QuestionnaireIntroScreen]; all question transitions
/// happen internally via [setState] so no separate per-question routes are needed.
class QuestionnaireSurveyScreen extends StatefulWidget {
  /// Start from a specific question index (0-based). Defaults to 0.
  final int initialIndex;

  const QuestionnaireSurveyScreen({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<QuestionnaireSurveyScreen> createState() =>
      _QuestionnaireSurveyScreenState();
}

class _QuestionnaireSurveyScreenState
    extends State<QuestionnaireSurveyScreen> {
  late int _currentIndex;

  /// Stores the selected answer labels per question index.
  /// Single-select: set contains exactly one item when answered.
  /// Multi-select : set can contain any number of items.
  final Map<int, Set<String>> _answers = {};

  // ── Derived getters ──────────────────────────────────────────────────────

  QuizQuestion get _q => kAssessmentQuestions[_currentIndex];
  Set<String> get _currentAnswers => _answers[_currentIndex] ?? {};
  bool get _hasAnswer => _currentAnswers.isNotEmpty;
  bool get _isLast => _currentIndex == kAssessmentQuestions.length - 1;
  int get _total => kAssessmentQuestions.length;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _total - 1);
  }

  // ── Event handlers ───────────────────────────────────────────────────────

  void _handleBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _handleOptionTap(String label) {
    final option = _q.options.firstWhere((o) => o.label == label);

    setState(() {
      if (_q.type == QuestionType.single) {
        // Radio behaviour – replace selection
        _answers[_currentIndex] = {label};
      } else {
        // Checkbox behaviour – toggle, respecting exclusivity
        final current = Set<String>.from(_currentAnswers);
        if (current.contains(label)) {
          current.remove(label);
        } else {
          if (option.isExclusive) {
            // "None of these" wipes all other picks
            current
              ..clear()
              ..add(label);
          } else {
            // Any normal pick removes exclusive options first
            final exclusives = _q.options
                .where((o) => o.isExclusive)
                .map((o) => o.label)
                .toSet();
            current
              ..removeAll(exclusives)
              ..add(label);
          }
        }
        _answers[_currentIndex] = current;
      }
    });
  }

  void _advance() {
    if (_isLast) {
      context.push(RouteNames.questionnaireResults);
    } else {
      setState(() => _currentIndex++);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ─────────────────────────────────────────────────
            _TopBar(
              onBack: _handleBack,
              currentStep: _currentIndex + 1,
              totalSteps: _total,
            ),

            // ── Progress bar ─────────────────────────────────────────────
            _AssessmentProgressBar(
              current: _currentIndex + 1,
              total: _total,
            ),

            // ── Scrollable question + options ────────────────────────────
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
                  question: _q,
                  selectedAnswers: _currentAnswers,
                  onOptionTap: _handleOptionTap,
                ),
              ),
            ),

            // ── Bottom actions ──────────────────────────────────────────
            _BottomActions(
              hasAnswer: _hasAnswer,
              isLast: _isLast,
              onContinue: _advance,
              onSkip: _advance,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPOSABLE WIDGETS  (private to this file)
// ═══════════════════════════════════════════════════════════════════════════════

// ── Top bar ──────────────────────────────────────────────────────────────────

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

// ── Progress bar ─────────────────────────────────────────────────────────────

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
          final fillWidth =
              (current / total) * constraints.maxWidth;
          return Stack(
            children: [
              // Track
              Container(
                height: 3,
                width: constraints.maxWidth,
                color: AppColors.inputBorder,
              ),
              // Fill
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

// ── Question body (title + options) ──────────────────────────────────────────

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
        // Question title
        Text(
          question.title,
          style: AppTypography.screenTitle.copyWith(fontSize: 22),
        ),

        // Optional coral hint (multi-select)
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

        // Options list
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

// ── Option card (single radio / multi checkbox) ───────────────────────────────

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
                // Label (+ optional subtitle)
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

                // Indicator  (circle = radio, rounded square = checkbox)
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

// ── Selection indicator (radio circle / checkbox square) ─────────────────────

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isRadio; // true → circle, false → rounded square

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

// ── Bottom action buttons ────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  final bool hasAnswer;
  final bool isLast;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  const _BottomActions({
    required this.hasAnswer,
    required this.isLast,
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
            onPressed: hasAnswer ? onContinue : null,
            backgroundColor:
                hasAnswer ? AppColors.primary : const Color(0xFFD0CBC6),
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: onSkip,
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
