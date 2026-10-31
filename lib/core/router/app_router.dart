import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_intro_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_next_steps_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_results_screen.dart';
import '../../features/questionnaire/presentation/questionnaire_survey_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/programs/presentation/program_detail_screen.dart';
import '../../features/programs/presentation/phase_detail_screen.dart';
import '../../features/programs/presentation/phase_learn_screen.dart';
import '../../features/programs/presentation/phase_watch_screen.dart';
import '../../features/programs/presentation/phase_activity_screen.dart';
import '../../features/programs/presentation/phase_quiz_screen.dart';
import '../../features/programs/presentation/lesson_detail_screen.dart';
import '../../features/programs/presentation/video_detail_screen.dart';
import '../../features/support/presentation/support_options_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import 'route_names.dart';

/// Riverpod Provider for GoRouter instance with Auth Guards
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _RiverpodRefreshListenable(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStateProvider);

      final currentLocation = state.location;
      final isAuthRoute = currentLocation == RouteNames.signIn ||
          currentLocation == RouteNames.signUp ||
          currentLocation == RouteNames.forgotPassword;

      // While checking initial auth state, remain on splash or requested page
      if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
        return null;
      }

      // If user is authenticated and trying to access sign-in or sign-up, redirect to dashboard
      if (authState.status == AuthStatus.authenticated && isAuthRoute) {
        return RouteNames.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) => _buildPage(const SplashScreen(), state),
      ),
      GoRoute(
        path: RouteNames.welcome,
        pageBuilder: (context, state) => _buildPage(const WelcomeScreen(), state),
      ),
      GoRoute(
        path: RouteNames.signUp,
        pageBuilder: (context, state) => _buildPage(const SignUpScreen(), state),
      ),
      GoRoute(
        path: RouteNames.signIn,
        pageBuilder: (context, state) => _buildPage(const SignInScreen(), state),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        pageBuilder: (context, state) => _buildPage(const ForgotPasswordScreen(), state),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        pageBuilder: (context, state) {
          final tabIndex = state.extra is int ? state.extra as int : 0;
          return _buildPage(DashboardScreen(initialIndex: tabIndex), state);
        },
      ),
      GoRoute(
        path: RouteNames.questionnaireIntro,
        pageBuilder: (context, state) {
          final userName = state.extra is String ? state.extra as String : 'Ramsey';
          return _buildPage(QuestionnaireIntroScreen(userName: userName), state);
        },
      ),
      GoRoute(
        path: RouteNames.questionnaireSurvey,
        pageBuilder: (context, state) => _buildPage(const QuestionnaireSurveyScreen(), state),
      ),
      // Legacy questionnaire routes redirecting to survey screen
      GoRoute(
        path: RouteNames.questionnaireQ1Goals,
        redirect: (context, state) => RouteNames.questionnaireSurvey,
      ),
      GoRoute(
        path: RouteNames.questionnaireQ2Mood,
        redirect: (context, state) => RouteNames.questionnaireSurvey,
      ),
      GoRoute(
        path: RouteNames.questionnaireQ3Stress,
        redirect: (context, state) => RouteNames.questionnaireSurvey,
      ),
      GoRoute(
        path: RouteNames.questionnaireResults,
        pageBuilder: (context, state) => _buildPage(const QuestionnaireResultsScreen(), state),
      ),
      GoRoute(
        path: RouteNames.questionnaireNextSteps,
        pageBuilder: (context, state) => _buildPage(const QuestionnaireNextStepsScreen(), state),
      ),
      GoRoute(
        path: RouteNames.supportOptions,
        pageBuilder: (context, state) => _buildPage(const SupportOptionsScreen(), state),
      ),
      GoRoute(
        path: RouteNames.programDetail,
        pageBuilder: (context, state) => _buildPage(const ProgramDetailScreen(), state),
      ),
      GoRoute(
        path: RouteNames.phaseDetail,
        pageBuilder: (context, state) => _buildPage(const PhaseDetailScreen(), state),
      ),
      GoRoute(
        path: RouteNames.phaseLearn,
        pageBuilder: (context, state) => _buildPage(const PhaseLearnScreen(), state),
      ),
      GoRoute(
        path: RouteNames.phaseWatch,
        pageBuilder: (context, state) => _buildPage(const PhaseWatchScreen(), state),
      ),
      GoRoute(
        path: RouteNames.phaseActivity,
        pageBuilder: (context, state) => _buildPage(const PhaseActivityScreen(), state),
      ),
      GoRoute(
        path: RouteNames.phaseQuiz,
        pageBuilder: (context, state) => _buildPage(const PhaseQuizScreen(), state),
      ),
      GoRoute(
        path: RouteNames.lessonDetail,
        pageBuilder: (context, state) => _buildPage(const LessonDetailScreen(), state),
      ),
      GoRoute(
        path: RouteNames.videoDetail,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPage(
            VideoDetailScreen(
              videoNumber: extra?['videoNumber'] ?? 1,
              totalVideos: extra?['totalVideos'] ?? 3,
              videoTitle: extra?['videoTitle'] ?? "Let's Redefine Mental Health",
              videoDescription: extra?['videoDescription'] ??
                  "Why mental health is something everyone has, not just a label for illness.",
              duration: extra?['duration'] ?? "1:12",
            ),
            state,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.error}'),
      ),
    ),
  );
});

/// Page transition builder
CustomTransitionPage<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
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
  );
}

/// Helper class to bridge Riverpod Provider updates to GoRouter refreshListenable
class _RiverpodRefreshListenable extends ChangeNotifier {
  _RiverpodRefreshListenable(Ref ref) {
    ref.listen<AuthState>(authStateProvider, (_, __) => notifyListeners());
  }
}
