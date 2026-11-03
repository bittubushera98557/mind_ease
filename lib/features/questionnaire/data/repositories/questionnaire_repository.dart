import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
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
}
