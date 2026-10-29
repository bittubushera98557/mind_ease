import 'package:flutter/material.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/mind_ease_logo.dart';
import '../../../core/widgets/mood_emojis.dart';

/// 1.02 Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // MindEase Colorful Community Logo
              const Center(
                child: MindEaseLogo(
                  size: 68,
                  showText: false,
                ),
              ),
              const SizedBox(height: 22),

              // Title
              Text(
                'Welcome to MindEase',
                textAlign: TextAlign.center,
                style: AppTypography.welcomeTitle,
              ),
              const SizedBox(height: 12),

              // Subtitle Description
              Text(
                AppConstants.welcomeDescription,
                textAlign: TextAlign.center,
                style: AppTypography.bodyWelcome,
              ),

              const Spacer(flex: 2),

              // 5 Expressive Mood Emojis
              const MoodEmojisRow(
                emojiSize: 36,
                initialSelected: MoodType.happy,
              ),

              const Spacer(flex: 3),

              // "Get started  →" Button
              AppButton(
                text: 'Get started',
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.signUp);
                },
              ),
              const SizedBox(height: 18),

              // "Already have an account? Sign in" Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.footerRegular,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteNames.signIn);
                    },
                    child: Text(
                      'Sign in',
                      style: AppTypography.linkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
