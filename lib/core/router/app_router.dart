import 'package:flutter/material.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_intro_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_next_steps_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_results_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_survey_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import 'route_names.dart';

/// MindEase Central Application Router
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _buildPageRoute(
          const SplashScreen(),
          settings,
        );

      case RouteNames.welcome:
        return _buildPageRoute(
          const WelcomeScreen(),
          settings,
        );

      case RouteNames.signUp:
        return _buildPageRoute(
          const SignUpScreen(),
          settings,
        );

      case RouteNames.signIn:
        return _buildPageRoute(
          const SignInScreen(),
          settings,
        );

      case RouteNames.forgotPassword:
        return _buildPageRoute(
          const ForgotPasswordScreen(),
          settings,
        );

      case RouteNames.questionnaireIntro:
        return _buildPageRoute(
          const QuestionnaireIntroScreen(),
          settings,
        );

      // New consolidated survey (all 9 questions in one screen)
      case RouteNames.questionnaireSurvey:
      // Legacy per-question routes — all redirect to the survey screen
      case RouteNames.questionnaireQ1Goals:
      case RouteNames.questionnaireQ2Mood:
      case RouteNames.questionnaireQ3Stress:
        return _buildPageRoute(
          const QuestionnaireSurveyScreen(),
          settings,
        );

      case RouteNames.questionnaireResults:
        return _buildPageRoute(
          const QuestionnaireResultsScreen(),
          settings,
        );

      case RouteNames.questionnaireNextSteps:
        return _buildPageRoute(
          const QuestionnaireNextStepsScreen(),
          settings,
        );

      default:
        return _buildPageRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        final fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 260),
    );
  }
}
