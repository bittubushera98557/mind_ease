import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
