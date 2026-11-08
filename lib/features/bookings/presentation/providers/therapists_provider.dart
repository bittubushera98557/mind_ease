import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/therapist_based_available_slots_resp.dart';
import '../../data/models/therapists_list_resp.dart';
import '../../data/repositories/therapists_repository.dart';

/// Provider for TherapistsRepository
final therapistsRepositoryProvider = Provider<TherapistsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TherapistsRepository(dioClient: dioClient);
});

/// FutureProvider that fetches therapists list GET /therapists
final therapistsListProvider =
    FutureProvider<TherapistsListResp>((ref) async {
  final repository = ref.watch(therapistsRepositoryProvider);
  return await repository.getTherapists();
});

/// FutureProviderFamily that fetches therapist available slots GET /therapists/{therapistId}/slots
final therapistSlotsProvider = FutureProvider.family
    <TherapistBasedAvailableSlotsResp, String>((ref, therapistId) async {
  if (therapistId.isEmpty) {
    return TherapistBasedAvailableSlotsResp(
      therapistId: '',
      sessionMinutes: 50,
      slots: [],
    );
  }
  final repository = ref.watch(therapistsRepositoryProvider);
  return await repository.getTherapistSlots(therapistId);
});
