import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pet_model.dart';

class PetRemoteDataSource {
  final SupabaseClient client;
  PetRemoteDataSource(this.client);

  Future<List<PetModel>> fetchPets(String familyId) async {
    final data = await client
        .from('pets')
        .select()
        .eq('family_id', familyId)
        .eq('status', 'Active');
    return (data as List).map((e) => PetModel.fromJson(e)).toList();
  }

  Future<PetModel> insertPet(Map<String, dynamic> pet) async {
    final data = await client.from('pets').insert(pet).select().single();
    return PetModel.fromJson(data);
  }

  Future<PetModel> updatePet(String id, Map<String, dynamic> updates) async {
    final data = await client.from('pets').update(updates).eq('id', id).select().single();
    return PetModel.fromJson(data);
  }
}
