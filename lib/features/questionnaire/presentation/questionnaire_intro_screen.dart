import 'package:flutter/material.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';

/// 1.06 Questionnaire Intro Screen – "Let's get to know you, [Name]"
class QuestionnaireIntroScreen extends StatelessWidget {
  final String userName;

  const QuestionnaireIntroScreen({
    Key? key,
    this.userName = 'Ramsey',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use name from route args if provided, else fallback to constructor param
    final String name =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? userName;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Pinned bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: AppButton(
            text: 'Start questionnaire',
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteNames.questionnaireSurvey,
              );
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Coral Header ──────────────────────────────────────────
          _QuestionnaireIntroHeader(name: name),

          // ── Feature Cards ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child:   Column(
                children: [
                  _FeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    iconColor: Color(0xFF5A8F5A),
                    iconBgColor: Color(0xFFDFEEDF),
                    title: 'Personalised suggestions',
                    subtitle:
                        'We use your answers to recommend program phases and a daily time goal.',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _FeatureCard(
                    icon: Icons.shield_outlined,
                    iconColor: Color(0xFF6B5CE7),
                    iconBgColor: Color(0xFFEDE9FB),
                    title: 'Private to you',
                    subtitle:
                        'Your answers are only used to tailor your experience.',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _FeatureCard(
                    icon: Icons.info_outlined,
                    iconColor: Color(0xFFB8860B),
                    iconBgColor: Color(0xFFFFF8DC),
                    title: 'Not a diagnosis',
                    subtitle:
                        "This is a check-in, not a clinical assessment. Skip anything you'd rather not answer.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header widget – coral gradient with decorative dark-fold, back button,
// time chip, big white title and subtitle
// ─────────────────────────────────────────────────────────────────────────────
class _QuestionnaireIntroHeader extends StatelessWidget {
  final String name;

  const _QuestionnaireIntroHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Painted coral background with decorative dark-red fold
          Positioned.fill(
            child: CustomPaint(
              painter: _HeaderPainter(),
            ),
          ),

          // Content on top of the painted background
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button row
                  CircularBackButton(
                    isLightOnDark: true,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Time chip
                  _TimePill(),
                  const SizedBox(height: AppSpacing.lg),

                  // Large headline
                  Text(
                    "Let's get to know you,\n$name",
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Subtitle
                  Text(
                    '9 quick questions so we can suggest where to start.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 14,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Time pill chip  "⏱ About 2 minutes"
// ─────────────────────────────────────────────────────────────────────────────
class _TimePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: AppSpacing.roundedPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 13,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(width: 5),
          Text(
            'About 2 minutes',
            style: AppTypography.bannerText.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual feature card  (white card, colored icon square)
// ─────────────────────────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.inputBorder, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.inputLabel.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painter – coral gradient fill + darker-red top-right fold
// (matches the same decorative language as CurvedHeader)
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Coral base fill
    final basePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB33A27), AppColors.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      basePaint,
    );

    // 2. Top-right darker mahogany diagonal fold wedge
    final foldPaint = Paint()
      ..color = const Color(0xFF9E3424).withOpacity(0.90)
      ..style = PaintingStyle.fill;

    final foldPath = Path();
    foldPath.moveTo(size.width * 0.62, 0);
    foldPath.lineTo(size.width, size.height * 0.55);
    foldPath.lineTo(size.width, 0);
    foldPath.close();
    canvas.drawPath(foldPath, foldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
