import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/program_detail_response_model.dart';
import '../../data/models/program_response_model.dart';
import '../../data/repositories/programs_repository.dart';

final programsRepositoryProvider = Provider<ProgramsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProgramsRepository(dioClient: dioClient);
});

/// FutureProvider that fetches programs list dynamically
final programsListProvider =
    FutureProvider.autoDispose<ProgramResponseModel>((ref) async {
  final repository = ref.watch(programsRepositoryProvider);
  return await repository.getPrograms();
});

/// FutureProviderFamily that fetches program detail dynamically by programId
final programDetailProvider = FutureProvider.autoDispose
    .family<ProgramDetailResponseModel, String>((ref, programId) async {
  final repository = ref.watch(programsRepositoryProvider);
  return await repository.getProgramDetail(programId);
});
