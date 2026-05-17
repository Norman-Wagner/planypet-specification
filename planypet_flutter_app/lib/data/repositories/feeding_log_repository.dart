import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/local/sync_database.dart';
import '../models/feeding_log_model.dart';

class FeedingLogRepository {
  FeedingLogRepository(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  Future<List<FeedingLogModel>> getForPet(String petId, {int limit = 50}) async {
    final db = await SyncDatabase.instance();
    final localRows = await db.query(
      'feeding_log',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'fed_at DESC',
      limit: limit,
    );
    final local = localRows.map(FeedingLogModel.fromDb).toList();

    try {
      final results = await Connectivity().checkConnectivity();
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) {
        final remote = await _client
            .from(AppConstants.feedingLogTable)
            .select()
            .eq('pet_id', petId)
            .order('fed_at', ascending: false)
            .limit(limit);
        return (remote as List).map((e) => FeedingLogModel.fromJson(e)).toList();
      }
    } catch (_) {/* fall back to local */}

    return local;
  }

  Future<FeedingLogModel> add({
    required String petId,
    required String familyId,
    required DateTime fedAt,
    String? foodName,
    int? portionGrams,
    String? notes,
  }) async {
    final entry = FeedingLogModel(
      id: _uuid.v4(),
      petId: petId,
      familyId: familyId,
      fedAt: fedAt,
      foodName: foodName,
      portionGrams: portionGrams,
      notes: notes,
    );

    final db = await SyncDatabase.instance();
    await db.insert('feeding_log', entry.toDb(synced: false));

    final results = await Connectivity().checkConnectivity();
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online) {
      try {
        await _client.from(AppConstants.feedingLogTable).insert(entry.toJson());
        await db.update('feeding_log', {'synced': 1}, where: 'id = ?', whereArgs: [entry.id]);
      } catch (_) {
        await SyncDatabase.enqueue(
          tableName: AppConstants.feedingLogTable,
          operation: 'insert',
          recordId: entry.id,
          payload: entry.toJson(),
        );
      }
    } else {
      await SyncDatabase.enqueue(
        tableName: AppConstants.feedingLogTable,
        operation: 'insert',
        recordId: entry.id,
        payload: entry.toJson(),
      );
    }
    return entry;
  }

  Future<FeedingLogModel?> latestForFamily(String familyId) async {
    final db = await SyncDatabase.instance();
    final rows = await db.query(
      'feeding_log',
      where: 'family_id = ?',
      whereArgs: [familyId],
      orderBy: 'fed_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : FeedingLogModel.fromDb(rows.first);
  }
}
