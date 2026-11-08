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
import '../../features/programs/data/models/program_detail_response_model.dart';
import '../../features/programs/presentation/program_detail_screen.dart';
import '../../features/programs/presentation/phase_detail_screen.dart';
import '../../features/programs/presentation/phase_learn_screen.dart';
import '../../features/programs/presentation/phase_watch_screen.dart';
import '../../features/programs/presentation/phase_activity_screen.dart';
import '../../features/programs/presentation/phase_quiz_screen.dart';
import '../../features/programs/presentation/lesson_detail_screen.dart';
import '../../features/programs/presentation/video_detail_screen.dart';
import '../../features/support/presentation/support_options_screen.dart';
import '../../features/profile/presentation/personal_information_screen.dart';
import '../../features/profile/presentation/change_password_screen.dart';
import '../../features/profile/presentation/privacy_policy_screen.dart';
import '../../features/profile/presentation/terms_of_use_screen.dart';
import '../../features/bookings/presentation/booking_step1_focus_screen.dart';
import '../../features/bookings/presentation/booking_step2_date_time_screen.dart';
import '../../features/bookings/presentation/booking_step3_review_pay_screen.dart';
import '../../features/bookings/presentation/booking_confirmation_screen.dart';
import '../../features/bookings/presentation/booking_detail_screen.dart';
import '../../features/bookings/presentation/booking_pre_session_screen.dart';
import '../../features/bookings/presentation/booking_pre_call_check_screen.dart';
import '../../features/bookings/presentation/booking_in_session_screen.dart';
import '../../features/bookings/presentation/booking_session_ended_screen.dart';
import '../../features/bookings/data/models/appointment_model.dart';
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
          currentLocation == RouteNames.forgotPassword ||
          currentLocation == RouteNames.welcome;

      // While checking initial auth state, remain on splash or requested page
      if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
        return null;
      }

      // If user is authenticated and trying to access welcome, sign-in, or sign-up, redirect to dashboard
      if (authState.status == AuthStatus.authenticated && isAuthRoute) {
        return RouteNames.dashboard;
      }

      // If user is unauthenticated and attempting to access a protected route, redirect to sign in
      if (authState.status == AuthStatus.unauthenticated &&
          !isAuthRoute &&
          currentLocation != RouteNames.splash) {
        return RouteNames.signIn;
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
        path: RouteNames.personalInformation,
        pageBuilder: (context, state) => _buildPage(const PersonalInformationScreen(), state),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        pageBuilder: (context, state) => _buildPage(const ChangePasswordScreen(), state),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        pageBuilder: (context, state) => _buildPage(const PrivacyPolicyScreen(), state),
      ),
      GoRoute(
        path: RouteNames.termsOfUse,
        pageBuilder: (context, state) => _buildPage(const TermsOfUseScreen(), state),
      ),
      GoRoute(
        path: RouteNames.bookingFocus,
        pageBuilder: (context, state) => _buildPage(const BookingStep1FocusScreen(), state),
      ),
      GoRoute(
        path: RouteNames.bookingDateTime,
        pageBuilder: (context, state) => _buildPage(const BookingStep2DateTimeScreen(), state),
      ),
      GoRoute(
        path: RouteNames.bookingReviewPay,
        pageBuilder: (context, state) => _buildPage(const BookingStep3ReviewPayScreen(), state),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingConfirmationScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.bookingDetail,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingDetailScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.bookingPreSession,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingPreSessionScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.bookingPreCallCheck,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingPreCallCheckScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.bookingInSession,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingInSessionScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.bookingSessionEnded,
        pageBuilder: (context, state) {
          final appt = state.extra as AppointmentModel?;
          return _buildPage(BookingSessionEndedScreen(appointment: appt), state);
        },
      ),
      GoRoute(
        path: RouteNames.programDetail,
        pageBuilder: (context, state) {
          final programId = state.extra as String? ?? '';
          return _buildPage(ProgramDetailScreen(programId: programId), state);
        },
      ),
      GoRoute(
        path: RouteNames.phaseDetail,
        pageBuilder: (context, state) {
          ProgramPhaseModel? phase;
          int phaseNumber = 1;
          String? programId;

          if (state.extra is ProgramPhaseModel) {
            phase = state.extra as ProgramPhaseModel;
            phaseNumber = phase.number > 0 ? phase.number : 1;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            if (map['phase'] is ProgramPhaseModel) {
              phase = map['phase'] as ProgramPhaseModel;
            }
            if (map['phaseNumber'] is int) {
              phaseNumber = map['phaseNumber'] as int;
            }
            if (map['programId'] is String) {
              programId = map['programId'] as String;
            }
          }

          return _buildPage(
            PhaseDetailScreen(
              phase: phase,
              phaseNumber: phaseNumber,
              phaseTitle: phase?.title.isNotEmpty == true
                  ? phase!.title
                  : "How's Your Head, Really?",
              programId: programId,
            ),
            state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.phaseLearn,
        pageBuilder: (context, state) {
          List<PhaseLessonModel>? lessons;
          int phaseNumber = 1;
          if (state.extra is List<PhaseLessonModel>) {
            lessons = state.extra as List<PhaseLessonModel>;
          } else if (state.extra is ProgramPhaseModel) {
            final phase = state.extra as ProgramPhaseModel;
            lessons = phase.lessons;
            if (phase.number > 0) phaseNumber = phase.number;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            if (map['lessons'] is List<PhaseLessonModel>) {
              lessons = map['lessons'] as List<PhaseLessonModel>;
            }
            if (map['phaseNumber'] is int) {
              phaseNumber = map['phaseNumber'] as int;
            }
          }
          return _buildPage(
            PhaseLearnScreen(
              lessons: lessons,
              phaseNumber: phaseNumber,
            ),
            state,
          );
        },
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
        pageBuilder: (context, state) {
          PhaseQuizModel? quiz;
          int phaseNumber = 1;
          String? programId;
          String? phaseId;

          if (state.extra is PhaseQuizModel) {
            quiz = state.extra as PhaseQuizModel;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            if (map['quiz'] is PhaseQuizModel) {
              quiz = map['quiz'] as PhaseQuizModel;
            }
            if (map['phaseNumber'] is int) {
              phaseNumber = map['phaseNumber'] as int;
            }
            if (map['programId'] is String) {
              programId = map['programId'] as String;
            }
            if (map['phaseId'] is String) {
              phaseId = map['phaseId'] as String;
            }
          }

          return _buildPage(
            PhaseQuizScreen(
              quiz: quiz,
              phaseNumber: phaseNumber,
              programId: programId,
              phaseId: phaseId,
            ),
            state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.lessonDetail,
        pageBuilder: (context, state) {
          PhaseLessonModel? lesson;
          int lessonNumber = 1;
          int totalLessons = 3;
          if (state.extra is PhaseLessonModel) {
            lesson = state.extra as PhaseLessonModel;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            if (map['lesson'] is PhaseLessonModel) {
              lesson = map['lesson'] as PhaseLessonModel;
            }
            if (map['lessonNumber'] is int) {
              lessonNumber = map['lessonNumber'] as int;
            }
            if (map['totalLessons'] is int) {
              totalLessons = map['totalLessons'] as int;
            }
          }
          return _buildPage(
            LessonDetailScreen(
              lesson: lesson,
              lessonNumber: lessonNumber,
              totalLessons: totalLessons,
            ),
            state,
          );
        },
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
              videoCompletePercent: extra?['videoCompletePercent'] ?? 90,
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
 /*   ref.listen<AuthState>(authStateProvider, (_, __) => notifyListeners());*/
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (previous?.status != next.status) {
        if (next.status == AuthStatus.authenticated ||
            (previous?.status == AuthStatus.authenticated &&
                next.status == AuthStatus.unauthenticated)) {
          notifyListeners();
        }
      }
    });
  }
}
