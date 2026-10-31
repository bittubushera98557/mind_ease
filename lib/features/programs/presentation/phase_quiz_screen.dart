import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';

enum _QuizScreenMode { intro, question, results }

class _QuizQuestionData {
  final int number;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String feedbackCorrect;
  final String feedbackIncorrect;

  const _QuizQuestionData({
    required this.number,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
  });
}

/// Phase Quiz Screen matching all 5 design screenshots dynamically
class PhaseQuizScreen extends StatefulWidget {
  final int phaseNumber;

  const PhaseQuizScreen({
    Key? key,
    this.phaseNumber = 1,
  }) : super(key: key);

  @override
  State<PhaseQuizScreen> createState() => _PhaseQuizScreenState();
}

class _PhaseQuizScreenState extends State<PhaseQuizScreen> {
  _QuizScreenMode _mode = _QuizScreenMode.intro;
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isSubmitted = false;
  int _score = 0;
  int _attemptsCount = 0;

  static const List<_QuizQuestionData> _questionsBank = [
    _QuizQuestionData(
      number: 1,
      question: 'Which statement best describes mental health?',
      options: [
        "It's only about mental illness",
        "How we think, feel and act, and it affects our body and habits too",
        "Something only some people have",
        "It's fixed and doesn't change",
      ],
      correctIndex: 1,
      feedbackCorrect:
          'Mental health is part of your overall health. Noticing it in your body and habits is the first skill.',
      feedbackIncorrect:
          'Everyone has mental health. It covers thoughts, feelings and behaviour, and it shows up in the body and in habits.',
    ),
    _QuizQuestionData(
      number: 2,
      question: 'Where can you usually notice mental health shifts first?',
      options: [
        'Only in clinical blood tests',
        'In your body, thoughts, and daily habits',
        'Only when a doctor points it out',
        'In your physical height and weight',
      ],
      correctIndex: 1,
      feedbackCorrect:
          'Changes in sleep, focus, and daily routines are early indicators of mental health shifts.',
      feedbackIncorrect:
          'Mental health shifts show up first in physical sensations, thought patterns, and everyday routines.',
    ),
    _QuizQuestionData(
      number: 3,
      question: 'Which is most worth paying attention to?',
      options: [
        'One stressful afternoon',
        'Feeling unlike yourself for several weeks, and it\'s affecting daily life',
        'Feeling nervous before a presentation',
        'Being tired after a long trip',
      ],
      correctIndex: 1,
      feedbackCorrect:
          'Changes that last and affect daily life matter more than one-off reactions to normal events.',
      feedbackIncorrect:
          'Persistent changes that impact day-to-day living are the key signs to notice.',
    ),
    _QuizQuestionData(
      number: 4,
      question: 'Is mental health the same as mental illness?',
      options: [
        'Yes, they are identical concepts',
        'No, everyone has mental health, while mental illness is a diagnosed condition',
        'No, only healthcare workers have mental health',
        'Yes, both cannot change over time',
      ],
      correctIndex: 1,
      feedbackCorrect:
          'Spot on! Everyone has mental health along a continuum, separate from formal clinical diagnoses.',
      feedbackIncorrect:
          'Mental health belongs to everyone and changes over time, unlike a diagnosed clinical condition.',
    ),
    _QuizQuestionData(
      number: 5,
      question: 'What is a great first step if you need support?',
      options: [
        'Ignore it and hope it goes away',
        'Talk to a GP, trusted friend, or support service',
        'Isolate yourself from everyone',
        'Stop taking care of basic daily habits',
      ],
      correctIndex: 1,
      feedbackCorrect:
          'Reaching out to a GP or support line is a safe and constructive starting point.',
      feedbackIncorrect:
          'Connecting with a healthcare professional or helpline is always the safest first step.',
    ),
  ];

  void _startQuiz() {
    setState(() {
      _mode = _QuizScreenMode.question;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = null;
      _isSubmitted = false;
      _score = 0;
    });
  }

  void _submitAnswer() {
    if (_selectedOptionIndex == null || _isSubmitted) return;

    final q = _questionsBank[_currentQuestionIndex];
    final isCorrect = _selectedOptionIndex == q.correctIndex;

    setState(() {
      _isSubmitted = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questionsBank.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _isSubmitted = false;
      });
    } else {
      setState(() {
        _attemptsCount++;
        _mode = _QuizScreenMode.results;
      });
    }
  }

  void _retryQuiz() {
    _startQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildCurrentModeScreen(),
      ),
    );
  }

  Widget _buildCurrentModeScreen() {
    switch (_mode) {
      case _QuizScreenMode.intro:
        return _buildIntroScreen();
      case _QuizScreenMode.question:
        return _buildQuestionScreen();
      case _QuizScreenMode.results:
        return _buildResultsScreen();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. INTRO SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildIntroScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircularBackButton(
                isLightOnDark: false,
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PHASE ${widget.phaseNumber} - QUIZ',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5D6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Icon(
                Icons.help_outline_rounded,
                size: 42,
                color: Color(0xFF8B5E00),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Phase ${widget.phaseNumber} quiz',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '5 questions on what you\'ve covered in this phase. You\'ll see feedback after each answer.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          Container(
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
            child: Column(
              children: [
                _buildStatRow('Questions', '${_questionsBank.length}'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF4EFEA)),
                ),
                _buildStatRow('Pass mark', '80% (4 of 5)'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF4EFEA)),
                ),
                _buildStatRow('Attempts so far', '$_attemptsCount'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_outlined,
                  size: 12,
                  color: Color(0xFF856404),
                ),
                const SizedBox(width: 4),
                Text(
                  'DRAFT QUESTIONS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF856404),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          AppButton(
            text: 'Start quiz \u2192',
            onPressed: _startQuiz,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. ACTIVE QUESTION SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildQuestionScreen() {
    final q = _questionsBank[_currentQuestionIndex];
    final total = _questionsBank.length;
    final progressVal = (_currentQuestionIndex + 1) / total;

    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: [
              CircularBackButton(
                isLightOnDark: false,
                onPressed: () {
                  setState(() {
                    _mode = _QuizScreenMode.intro;
                  });
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PHASE ${widget.phaseNumber} QUIZ',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  '${_currentQuestionIndex + 1} of $total',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progressVal,
              minHeight: 4,
              backgroundColor: const Color(0xFFE8E2DA),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUESTION ${q.number} \u00b7 MULTIPLE CHOICE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  q.question,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 20),

                // Options list
                ...List.generate(q.options.length, (optIdx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildOptionCard(q, optIdx),
                  );
                }),

                // Feedback Banner if submitted
                if (_isSubmitted) ...[
                  const SizedBox(height: 8),
                  _buildFeedbackBanner(q),
                ],

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),

        // Bottom Action Button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: _isSubmitted
              ? AppButton(
                  text: 'Next question \u2192',
                  onPressed: _nextQuestion,
                )
              : AppButton(
                  text: 'Submit answer',
                  backgroundColor: _selectedOptionIndex != null
                      ? AppColors.primary
                      : const Color(0xFFD0CBC6),
                  onPressed: _selectedOptionIndex != null ? _submitAnswer : null,
                ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(_QuizQuestionData q, int optIdx) {
    final letters = ['A', 'B', 'C', 'D'];
    final optionText = q.options[optIdx];
    final isSelected = _selectedOptionIndex == optIdx;
    final isCorrect = optIdx == q.correctIndex;

    Color borderColor = AppColors.inputBorder;
    Color bgColor = AppColors.surface;
    Widget leadingWidget = Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFF4EFEA),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letters[optIdx],
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );

    if (!_isSubmitted) {
      if (isSelected) {
        borderColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.04);
      }
    } else {
      // Submitted state
      if (isCorrect) {
        borderColor = const Color(0xFF7CA95B);
        bgColor = const Color(0xFFF1F8EE);
        leadingWidget = Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF7CA95B),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
        );
      } else if (isSelected && !isCorrect) {
        borderColor = const Color(0xFFD9534F);
        bgColor = const Color(0xFFFDF1F0);
        leadingWidget = Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFD9534F),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected || (_isSubmitted && isCorrect) ? 1.5 : 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isSubmitted
              ? null
              : () {
                  setState(() {
                    _selectedOptionIndex = optIdx;
                  });
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                leadingWidget,
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner(_QuizQuestionData q) {
    final isCorrect = _selectedOptionIndex == q.correctIndex;
    final bannerBg = isCorrect ? const Color(0xFFF1F8EE) : const Color(0xFFFDF1F0);
    final headerColor = isCorrect ? const Color(0xFF3B6E2B) : const Color(0xFFB33A27);
    final headerText = isCorrect ? 'Correct' : 'Not quite';
    final bodyText = isCorrect ? q.feedbackCorrect : q.feedbackIncorrect;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: headerColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bodyText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. RESULTS SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildResultsScreen() {
    final total = _questionsBank.length;
    final percentage = ((_score / total) * 100).round();
    final isPassed = percentage >= 80;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircularBackButton(
                isLightOnDark: false,
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PHASE ${widget.phaseNumber} - QUIZ RESULTS',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),

          // Circular Gauge Ring
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: _score / total,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFEFECE8),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPassed ? const Color(0xFF7CA95B) : const Color(0xFFE57324),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$_score of $total correct',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isPassed ? const Color(0xFFE2F0D9) : const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPassed ? 'Passed!' : 'Not passed yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPassed ? const Color(0xFF3B6E2B) : const Color(0xFF856404),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            isPassed ? 'Great job!' : 'Almost there',
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              isPassed
                  ? 'You passed the quiz! You\'re ready to move forward in your program.'
                  : 'You need 80% to pass. Have another look at the lessons, then try again. There\'s no limit on attempts.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stats Card
          Container(
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
            child: Column(
              children: [
                _buildStatRow('Score', '$_score / $total'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF4EFEA)),
                ),
                _buildStatRow('Percentage', '$percentage%'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF4EFEA)),
                ),
                _buildStatRow('Pass mark', '80%'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFF4EFEA)),
                ),
                _buildStatRow('Attempt', '$_attemptsCount'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Action Buttons: Retry & Back to phase
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _retryQuiz,
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.textPrimary),
                  label: Text(
                    'Retry',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Back to phase',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
