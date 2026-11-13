/// API Endpoint paths
class ApiEndpoints {
  ApiEndpoints._();

  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-code';
  static const String resetPassword = '/auth/reset-password';

/*forget password without login*/
  static const String passwordResetForget = '/auth/password-reset';

  /*profile section*/
  static const String logout = '/auth/logout';
  static const String currentUser = '/me'; // it will be hit with bearer token
  static const String deleteMyPhoto = '/me/photo'; // it will be hit with bearer token
  static const String password = '/me/password'; //  for update password from profile

/*support content */
  static const String  supportResources = '/support-resources'; //  for get support information


   static const String mePoints = '/me/points'; // it will be hit with bearer token
  static const String meAssessment = '/me/assessment'; // it will be hit with bearer token
  static const String tokenRefresh = '/auth/refresh'; // {"refreshToken": "string" }
  static const String bookings = '/me/bookings';
  static const String config = '/config';
  static const String questionnairesOnboarding = '/questionnaires/onboarding';
  static const String programs = '/programs';
  static const String programDetailWithId = '/programs/{programId}';
  static const String readLesson = '/me/programs/{programId}/lessons/{lessonId}/read';

 //need to implement below

  static const String therapistsList = '/therapists';
  static const String focusAreas = '/focus-areas';
  static const String therapistsDetailById = '/therapists/{therapistId}';
  static const String therapistBasedSlotsApi = '/therapists/{therapistId}/slots';



  // static const String dashboard = '/panel/dashboard';

  // Telehealth / Zoom Video SDK Token endpoint
  static const String telehealthToken = '/telehealth/token';
}


/*
 static const String deleteMyPhoto = '/me/photo'; // it will be hit with bearer token


i need to fix these things from backend side:-

in update profile time
api  = '/me'; // we need to submit image on server and actual image url in get response


https://api.mindease.me/v1/me/assessment submiting answers based on step but when getting data it returns only last submitted step, we need recomended phases based on submitting questionaris

  api = '/programs/{programId}';
we need actual questions and videos in this api. currently its showing videoUrl as null "mediaUrl": null,
          "thumbnailUrl": null

          , and also clear the types of question, because in UI there is fill in the blanks but
        "prompts": [
          {
            "id": "q1",
            "q": "Placeholder question 1?",
            "chips": [
              "calm",
              "tired"
            ],
            "optional": true
          },
          {
            "id": "q2",
            "q": "Placeholder question 2?",
            "chips": [],
            "optional": true
          }




   api  '/therapists';
we need this list based on my submitted interest and questionaries (asked before calendar screen)



--
in programs section  i need api for submit answer of quiz's questions
i need api for markLessonAsRead(lessonId)
i need api for submit activity (activityId)
i need api for videoWatched(videoId)

based on it  -  i need to show "continue where you left" on home screen and "Your focus"

 --- - -- - -- - -- --
need to discuss screen after signup- questionnaire complete for "recommended programs"/"focus phases"/"your plan"/

 --- - -- - -- - -- --

in  '/therapists';
and
 api  = '/therapists/{therapistId}';

[
  {
    "id": "01a1a257-5d82-7358-ad68-810e45a5d262",
    "name": "Dr Paras",
    "bio": "Test",
    "specialties": [],


there is getting empty specialties array for each therapist, we need speciality skills

--------
https://api.mindease.me/v1/me/bookings
book a session api's params need to be based on UI screen.
like focus, dateTimeSlot, mobileNumber, therapistId, paymentToken,

 */

//
/*
1. auth module done
  -create account
  - signin
  - refresh token
  - request a a password reset link email
  - sign out

2. account
  -get my account
  - update my profile
  -delete my account

 3. app settings





account


* */