import 'package:flutter/material.dart';
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
      subtitle: "You need to understand your mental health better",
      color: AppColors.primary,
    ),
    _FocusPhase(
      number: 2,
      title: 'Check Yourself, Kindly',
      subtitle: 'Talking about feelings has been activated.',
      color: Color(0xFFF4A261),
    ),
    _FocusPhase(
      number: 3,
      title: 'Safe to Feel, Safe to Speak',
      subtitle: 'Talking about feelings can be hard for you',
      color: AppColors.accentTeal,
    ),
    _FocusPhase(
      number: 4,
      title: 'Mental Health First Aid',
      subtitle: 'You need to support someone you care about',
      color: AppColors.moodWorried,
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
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
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
            ),
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
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Questionnaire complete chip
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            // alignment: Alignment.,
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
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                //
                          //
                          "Your starting point",
                          style: AppTypography.displayMedium.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "Based on your answers, here's where we suggest you focus.",
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppSpacing.roundedPill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.headset_mic_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Support options',
                                  style: AppTypography.buttonLarge.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Recommended program card
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RECOMMENDED FOR YOU',
                        style: AppTypography.inputLabel.copyWith(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildRecommendedCard(),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Your focus phases
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    'Your focus phases',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                ...List.generate(_phases.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.xl,
                      right: AppSpacing.xl,
                      bottom: AppSpacing.sm,
                    ),
                    child: _buildPhaseCard(_phases[i]),
                  );
                }),

                const SizedBox(height: AppSpacing.xxl),

                // Your plan section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    'Your plan',
                    style: AppTypography.screenTitle.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: _buildPlanSection(),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Disclaimer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    'These suggestions come from your answers. They start to personalise as you use the profile; the questionnaire anytime from your profile.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl + AppSpacing.xxxl),
              ],
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
            text: "OK, let's get started",
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.questionnaireNextSteps);
            },
          ),
        ),
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RECOMMENDED PROGRAM',
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Mental Health First Aid Self-Reflection Program',
                  style: AppTypography.inputLabel.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 3),
                Text(
                  'Remember to start at Phase 1. The phases below match what you highlighted.',
                  style: AppTypography.bodyMedium.copyWith(fontSize: 12),
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: phase.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${phase.number}',
                style: AppTypography.inputLabel.copyWith(
                  color: phase.color,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase.title,
                  style: AppTypography.inputLabel.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  phase.subtitle,
                  style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSection() {
    return Column(
      children: [
        _buildPlanItem(
          icon: Icons.schedule_rounded,
          text: '10 minutes a day',
          subtext: 'Daily bite goal',
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildPlanItem(
          icon: Icons.ondemand_video_rounded,
          text: 'Short videos',
          subtext: 'You\u0027ll highlight 3 items from each module',
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildPlanItem(
          icon: Icons.forum_rounded,
          text: 'Consider talking to a professional',
          subtext: "Therapy booking is coming to MindEase. It's a great next step.",
        ),
      ],
    );
  }

  Widget _buildPlanItem({
    required IconData icon,
    required String text,
    required String subtext,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: AppSpacing.roundedSm,
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTypography.inputLabel.copyWith(fontSize: 13.5),
              ),
              Text(
                subtext,
                style: AppTypography.bodyMedium.copyWith(fontSize: 12),
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
  final String subtitle;
  final Color color;

  const _FocusPhase({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
