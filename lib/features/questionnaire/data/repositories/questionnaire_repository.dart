import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/assessment_response_model.dart';
import '../models/onboarding_questionnaire_model.dart';

/// Repository for handling Questionnaire API operations
class QuestionnaireRepository {
  final DioClient _dioClient;

  QuestionnaireRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Fetches onboarding questionnaire GET /questionnaires/onboarding
  Future<OnboardingQuestionnaireModel> getOnboardingQuestionnaire() async {
    final response = await _dioClient.get<OnboardingQuestionnaireModel>(
      ApiEndpoints.questionnairesOnboarding,
      fromJson: (json) => OnboardingQuestionnaireModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to load questionnaire');
  }

  /// Submits user assessment answer for step via PUT /me/assessment
  Future<AssessmentResponseModel> submitAssessmentStep({
    required List<String> answers,
    required int step,
    String? completedAt,
    bool nextStepsSeen = false,
    String? questionnaireVersion,
  }) async {
    final body = <String, dynamic>{
      'answers': answers,
      'step': step,
      if (completedAt != null) 'completedAt': completedAt,
      'nextStepsSeen': nextStepsSeen,
      if (questionnaireVersion != null && questionnaireVersion.isNotEmpty)
        'questionnaireVersion': questionnaireVersion,
    };

    final response = await _dioClient.put<AssessmentResponseModel>(
      ApiEndpoints.meAssessment,
      body: body,
      fromJson: (json) =>
          AssessmentResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Failed to submit assessment step');
  }
}
