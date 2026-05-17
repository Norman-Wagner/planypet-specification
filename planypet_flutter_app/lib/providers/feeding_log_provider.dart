import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/feeding_log_model.dart';
import '../data/repositories/feeding_log_repository.dart';
import 'pet_provider.dart';

final feedingLogRepositoryProvider = Provider<FeedingLogRepository>((ref) {
  return FeedingLogRepository(ref.watch(supabaseClientProvider));
});

final feedingLogForPetProvider =
    FutureProvider.autoDispose.family<List<FeedingLogModel>, String>((ref, petId) async {
  return ref.watch(feedingLogRepositoryProvider).getForPet(petId);
});

final latestFeedingProvider =
    FutureProvider.autoDispose<FeedingLogModel?>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return null;
  return ref.watch(feedingLogRepositoryProvider).latestForFamily(familyId);
});
