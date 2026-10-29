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

 // static const String questionnaireNextSteps = '/questionnaire/next-steps';

  // Single data-driven survey screen (replaces Q1/Q2/Q3 in the main flow)
  static const String questionnaireSurvey = '/questionnaire/survey';
}
