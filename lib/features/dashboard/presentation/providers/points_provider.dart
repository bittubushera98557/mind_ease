import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/models/points_model.dart';
import '../../data/repositories/points_repository.dart';

/// Provider for PointsRepository
final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PointsRepository(dioClient: dioClient);
});

/// FutureProvider that fetches user points via GET /me/points
final userPointsProvider = FutureProvider<PointsModel>((ref) async {
  final repository = ref.watch(pointsRepositoryProvider);
  return await repository.getPoints();
});
