import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/support_resources_response_model.dart';
import '../../data/repositories/support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SupportRepository(dioClient: dioClient);
});

/// FutureProvider that fetches support resources dynamically
final supportResourcesProvider =
    FutureProvider.autoDispose<SupportResourcesResponseModel>((ref) async {
  final repository = ref.watch(supportRepositoryProvider);
  return await repository.getSupportResources();
});
