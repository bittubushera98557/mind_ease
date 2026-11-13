import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/focus_area_resp.dart';
import '../../data/repositories/focus_areas_repository.dart';

/// Provider for FocusAreasRepository
final focusAreasRepositoryProvider = Provider<FocusAreasRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FocusAreasRepository(dioClient: dioClient);
});

/// FutureProvider that fetches focus areas list GET /focus-areas
final focusAreasListProvider =
    FutureProvider<List<FocusAreaResp>>((ref) async {
  final repository = ref.watch(focusAreasRepositoryProvider);
  return await repository.getFocusAreas();
});
