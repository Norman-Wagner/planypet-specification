import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/local/sync_database.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  ReminderRepository(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  Future<List<ReminderModel>> getForFamily(String familyId) async {
    final db = await SyncDatabase.instance();
    final localRows = await db.query(
      'reminders',
      where: 'family_id = ?',
      whereArgs: [familyId],
      orderBy: 'completed ASC, due_at ASC',
    );
    final local = localRows.map(ReminderModel.fromDb).toList();

    try {
      final results = await Connectivity().checkConnectivity();
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) {
        final remote = await _client
            .from(AppConstants.remindersTable)
            .select()
            .eq('family_id', familyId)
            .order('due_at');
        return (remote as List).map((e) => ReminderModel.fromJson(e)).toList();
      }
    } catch (_) {/* fall back to local */}

    return local;
  }

  Future<ReminderModel> add({
    required String familyId,
    required String title,
    required DateTime dueAt,
    String? petId,
  }) async {
    final reminder = ReminderModel(
      id: _uuid.v4(),
      familyId: familyId,
      title: title,
      dueAt: dueAt,
      petId: petId,
    );

    final db = await SyncDatabase.instance();
    await db.insert('reminders', reminder.toDb(synced: false));

    await _pushOrEnqueue(
      operation: 'insert',
      payload: reminder.toJson(),
      recordId: reminder.id,
    );
    return reminder;
  }

  Future<ReminderModel> markComplete(ReminderModel reminder) async {
    final updated = reminder.copyWith(completed: true, completedAt: DateTime.now().toUtc());
    final db = await SyncDatabase.instance();
    await db.update(
      'reminders',
      updated.toDb(synced: false),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );

    await _pushOrEnqueue(
      operation: 'update',
      payload: {
        'completed': true,
        'completed_at': updated.completedAt!.toIso8601String(),
      },
      recordId: reminder.id,
    );
    return updated;
  }

  Future<void> _pushOrEnqueue({
    required String operation,
    required Map<String, dynamic> payload,
    required String recordId,
  }) async {
    final results = await Connectivity().checkConnectivity();
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online) {
      try {
        if (operation == 'insert') {
          await _client.from(AppConstants.remindersTable).insert(payload);
        } else if (operation == 'update') {
          await _client
              .from(AppConstants.remindersTable)
              .update(payload)
              .eq('id', recordId);
        }
        final db = await SyncDatabase.instance();
        await db.update('reminders', {'synced': 1}, where: 'id = ?', whereArgs: [recordId]);
        return;
      } catch (_) {/* fall through to enqueue */}
    }
    await SyncDatabase.enqueue(
      tableName: AppConstants.remindersTable,
      operation: operation,
      recordId: recordId,
      payload: payload,
    );
  }
}
