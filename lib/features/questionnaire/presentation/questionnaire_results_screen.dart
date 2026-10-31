import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

/// 1.10 Questionnaire Results Screen – "You don't have to wait to get support"
class QuestionnaireResultsScreen extends StatelessWidget {
  const QuestionnaireResultsScreen({Key? key}) : super(key: key);

  static const List<_FocusPhase> _phases = [
    _FocusPhase(
      number: 1,
      title: "How's Your Head, Really?",
      subtitles: ["• You want to build healthier habits"],
      color: Color(0xFF88A75E),
    ),
    _FocusPhase(
      number: 2,
      title: 'Check Yourself, Kindly',
      subtitles: [
        "• Your stress has been high lately",
        "• You've noticed stress showing up in your body",
        "• Your sleep has been unsettled",
      ],
      color: Color(0xFFE57324),
    ),
    _FocusPhase(
      number: 3,
      title: 'Safe to Feel, Safe to Speak',
      subtitles: ["• Talking about feelings can be hard for you"],
      color: Color(0xFF8B7AD8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Coral collapsible header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: SizedBox(),/*Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.55),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),*/
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB33A27), AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Questionnaire complete chip
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: AppSpacing.roundedPill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Questionnaire complete',
                                  style: AppTypography.bannerText.copyWith(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "Your starting point",
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Based on your answers, here's where we suggest you focus.",
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // ── Support Card ──────────────────────────────────────
                  _buildSupportCard(context),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Recommended Program Card ──────────────────────────
                  _buildRecommendedCard(),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Your Focus Phases ─────────────────────────────────
                  Text(
                    'Your focus phases',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  ...List.generate(_phases.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _buildPhaseCard(_phases[i]),
                    );
                  }),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Your Plan ─────────────────────────────────────────
                  Text(
                    'Your plan',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildPlanSection(),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Disclaimer ────────────────────────────────────────
                  Text(
                    'These suggestions come from your answers. They aren\'t a diagnosis. You can retake the questionnaire anytime from your profile.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl + AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: AppButton(
            text: "Done ",
            onPressed: () {
              context.push(RouteNames.questionnaireNextSteps);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF1F0), // Light pink/coral tint
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: const Color(0xFFF4D6D2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You don't have to wait to get support",
            style: AppTypography.inputLabel.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Some of your answers suggest things have been hard lately. Talking to a GP or a support line can help, alongside this program.",
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.push(RouteNames.supportOptions),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppSpacing.roundedPill,
                  border: Border.all(color: AppColors.inputBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Support options',
                      style: AppTypography.buttonLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RECOMMENDED PROGRAM',
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mental Health First Aid Self-Reflection Program',
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Everyone starts at Phase 1. The phases below match what you told us.',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(_FocusPhase phase) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: phase.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${phase.number}',
                style: AppTypography.inputLabel.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase.title,
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                ...phase.subtitles.map(
                  (sub) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      sub,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          _buildPlanItem(
            icon: Icons.schedule_rounded,
            text: '20+ minutes a day',
            subtext: 'Daily time goal',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.inputBorder),
          ),
          _buildPlanItem(
            icon: Icons.menu_book_rounded,
            text: 'A mix of formats',
            subtext: "We'll highlight these first in each phase",
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.inputBorder),
          ),
          _buildPlanItem(
            icon: Icons.person_outline_rounded,
            text: 'Consider talking to a professional',
            subtext: "Therapy booking is coming to MindEase. A GP is a good first step.",
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem({
    required IconData icon,
    required String text,
    required String subtext,
  }) {
    String formattedSubtext = subtext;
    if (subtext.contains("A GP is a good first step.")) {
      formattedSubtext = "Therapy booking is coming to MindEase.\nA GP is a good first step.";
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: AppSpacing.roundedSm,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTypography.inputLabel.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formattedSubtext,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FocusPhase {
  final int number;
  final String title;
  final List<String> subtitles;
  final Color color;

  const _FocusPhase({
    required this.number,
    required this.title,
    required this.subtitles,
    required this.color,
  });
}
