import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder_model.dart';
import '../data/repositories/reminder_repository.dart';
import 'pet_provider.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(supabaseClientProvider));
});

final remindersProvider = FutureProvider.autoDispose<List<ReminderModel>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  return ref.watch(reminderRepositoryProvider).getForFamily(familyId);
});

final upcomingRemindersProvider =
    FutureProvider.autoDispose<List<ReminderModel>>((ref) async {
  final all = await ref.watch(remindersProvider.future);
  final now = DateTime.now();
  return all.where((r) => !r.completed && r.dueAt.isAfter(now)).take(5).toList();
});
