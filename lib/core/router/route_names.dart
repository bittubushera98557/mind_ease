/// Named Route Constants
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String forgotPassword = '/forgot-password';

  // Questionnaire flow (1.06 – 1.11)
  static const String questionnaireIntro = '/questionnaire/intro';
  static const String questionnaireQ1Goals = '/questionnaire/q1-goals';
  static const String questionnaireQ2Mood = '/questionnaire/q2-mood';
  static const String questionnaireQ3Stress = '/questionnaire/q3-stress';
  static const String questionnaireResults = '/questionnaire/results';
  static const String questionnaireNextSteps = '/questionnaire/next-steps';
  static const String questionnaireSurvey = '/questionnaire/survey';

  // Main Dashboard & Tab Navigation (2.01 – 2.04)
  static const String dashboard = '/dashboard';

  // Profile Sub-screens
  static const String personalInformation = '/profile/personal-information';
  static const String changePassword = '/profile/change-password';
  static const String privacyPolicy = '/profile/privacy-policy';
  static const String termsOfUse = '/profile/terms-of-use';

  // Booking Flow (5.01 – 5.11)
  static const String bookingFocus = '/booking/step-1-focus';
  static const String bookingDateTime = '/booking/step-2-date-time';
  static const String bookingReviewPay = '/booking/step-3-review-pay';
  static const String bookingConfirmation = '/booking/confirmation';
  static const String bookingDetail = '/booking/detail';
  static const String bookingPreSession = '/booking/pre-session';
  static const String bookingPreCallCheck = '/booking/pre-call-check';
  static const String bookingInSession = '/booking/in-session';
  static const String bookingSessionEnded = '/booking/session-ended';

  // Support Options / Get Help Now
  static const String supportOptions = '/support-options';

  // Program Detail / Overview
  static const String programDetail = '/program-detail';

  // Phase Detail
  static const String phaseDetail = '/phase-detail';

  // Phase Learn
  static const String phaseLearn = '/phase-learn';

  // Phase Watch
  static const String phaseWatch = '/phase-watch';

  // Phase Activity
  static const String phaseActivity = '/phase-activity';

  // Phase Quiz
  static const String phaseQuiz = '/phase-quiz';

  // Video Detail
  static const String videoDetail = '/video-detail';

  // Lesson Detail
  static const String lessonDetail = '/lesson-detail';
}
