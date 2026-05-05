import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet_model.dart';
import '../../core/constants/app_constants.dart';

class PetRepository {
  final SupabaseClient _client;
  PetRepository(this._client);

  Future<List<PetModel>> getPetsForFamily(String familyId) async {
    final response = await _client
        .from(AppConstants.petsTable)
        .select()
        .eq('family_id', familyId)
        .eq('status', 'Active')
        .order('name');
    return (response as List).map((e) => PetModel.fromJson(e)).toList();
  }

  Future<PetModel?> getPetById(String petId) async {
    final response = await _client
        .from(AppConstants.petsTable)
        .select()
        .eq('id', petId)
        .maybeSingle();
    return response != null ? PetModel.fromJson(response) : null;
  }

  Future<PetModel> createPet(Map<String, dynamic> data) async {
    final response = await _client
        .from(AppConstants.petsTable)
        .insert(data)
        .select()
        .single();
    return PetModel.fromJson(response);
  }

  Future<PetModel> updatePet(String petId, Map<String, dynamic> data) async {
    final response = await _client
        .from(AppConstants.petsTable)
        .update(data)
        .eq('id', petId)
        .select()
        .single();
    return PetModel.fromJson(response);
  }

  Future<void> deletePet(String petId) async {
    await _client
        .from(AppConstants.petsTable)
        .update({'status': 'Inactive'})
        .eq('id', petId);
  }

  Future<String> uploadPetPhoto(String petId, List<int> bytes, String fileName) async {
    final path = '${Supabase.instance.client.auth.currentUser!.id}/$petId/$fileName';
    await _client.storage.from(AppConstants.petPhotosBucket).uploadBinary(path, bytes);
    return _client.storage.from(AppConstants.petPhotosBucket).getPublicUrl(path);
  }
}
