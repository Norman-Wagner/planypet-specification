import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/pet_model.dart';
import '../data/repositories/pet_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository(ref.watch(supabaseClientProvider));
});

final currentFamilyIdProvider = StateProvider<String?>((ref) => null);

final petsProvider = FutureProvider.autoDispose<List<PetModel>>((ref) async {
  final familyId = ref.watch(currentFamilyIdProvider);
  if (familyId == null) return [];
  final repo = ref.watch(petRepositoryProvider);
  return repo.getPetsForFamily(familyId);
});

final selectedPetProvider = StateProvider<PetModel?>((ref) => null);
