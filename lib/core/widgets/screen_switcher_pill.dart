import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/route_names.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Interactive Floating Screen Switcher for fast previewing all 5 screens
class ScreenSwitcherPill extends StatelessWidget {
  final Widget child;

  const ScreenSwitcherPill({
    Key? key,
    required this.child,
  }) : super(key: key);

  void _showScreenSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Quick Screen Navigator',
                  style: AppTypography.screenTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Switch between the MindEase screens:',
                  style: AppTypography.inputHelper,
                ),
                const SizedBox(height: 16),
                _buildScreenItem(
                  context: ctx,
                  number: '1.01',
                  title: 'Splash Screen',
                  route: RouteNames.splash,
                  icon: Icons.spa_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.02',
                  title: 'Welcome Screen',
                  route: RouteNames.welcome,
                  icon: Icons.sentiment_satisfied_alt_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.03',
                  title: 'Sign Up ("Sign Up For Free")',
                  route: RouteNames.signUp,
                  icon: Icons.person_add_alt_1_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.04',
                  title: 'Sign In ("Sign In To MindEase")',
                  route: RouteNames.signIn,
                  icon: Icons.login_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.05',
                  title: 'Forgot Password',
                  route: RouteNames.forgotPassword,
                  icon: Icons.lock_reset_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.06',
                  title: 'Questionnaire Intro',
                  route: RouteNames.questionnaireIntro,
                  icon: Icons.quiz_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.07–1.09',
                  title: 'Assessment Survey (9 questions)',
                  route: RouteNames.questionnaireSurvey,
                  icon: Icons.checklist_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.10',
                  title: 'Results',
                  route: RouteNames.questionnaireResults,
                  icon: Icons.insights_rounded,
                ),
                _buildScreenItem(
                  context: ctx,
                  number: '1.11',
                  title: 'Your Next Steps',
                  route: RouteNames.questionnaireNextSteps,
                  icon: Icons.rocket_launch_rounded,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreenItem({
    required BuildContext context,
    required String number,
    required String title,
    required String route,
    required IconData icon,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primarySubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        '$number  $title',
        style: AppTypography.inputLabel.copyWith(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
      onTap: () {
        Navigator.of(context).pop();
        context.push(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 16,
          bottom: 20,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showScreenSelector(context),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers_outlined, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'Screens',
                        style: AppTypography.buttonLarge.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
