import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/assessment_response_model.dart';
import '../../data/models/onboarding_questionnaire_model.dart';
import '../../data/repositories/questionnaire_repository.dart';

final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return QuestionnaireRepository(dioClient: dioClient);
});

/// FutureProvider that fetches onboarding questionnaire dynamically
final onboardingQuestionnaireProvider =
    FutureProvider.autoDispose<OnboardingQuestionnaireModel>((ref) async {
  final repository = ref.watch(questionnaireRepositoryProvider);
  return await repository.getOnboardingQuestionnaire();
});

/// StateProvider to store the latest assessment submission response in memory
final lastAssessmentResponseProvider =
    StateProvider<AssessmentResponseModel?>((ref) => null);

/// FutureProvider that fetches assessment GET /me/assessment
final assessmentResponseProvider =
    FutureProvider.autoDispose<AssessmentResponseModel>((ref) async {
  final repository = ref.watch(questionnaireRepositoryProvider);
  return await repository.getAssessment();
});
