import 'package:hive_flutter/hive_flutter.dart';
import '../../models/pet_model.dart';

class PetLocalDataSource {
  static const String _boxName = 'pets_cache';

  Future<Box> get _box async => Hive.openBox(_boxName);

  Future<void> cachePets(String familyId, List<PetModel> pets) async {
    final box = await _box;
    final data = pets.map((p) => p.toJson()..['id'] = p.id).toList();
    await box.put('pets_$familyId', data);
  }

  Future<List<PetModel>> getCachedPets(String familyId) async {
    final box = await _box;
    final data = box.get('pets_$familyId') as List?;
    if (data == null) return [];
    return data.map((e) => PetModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> clearCache() async {
    final box = await _box;
    await box.clear();
  }
}
