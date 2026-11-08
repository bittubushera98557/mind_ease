import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/config_response_model.dart';
import '../../data/repositories/config_repository.dart';

/// Provider for ConfigRepository
final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ConfigRepository(dioClient: dioClient);
});

/// FutureProvider that fetches system configuration dynamically from GET /config
final configProvider = FutureProvider<ConfigResponseModel>((ref) async {
  final repository = ref.watch(configRepositoryProvider);
  return await repository.getConfig();
});
