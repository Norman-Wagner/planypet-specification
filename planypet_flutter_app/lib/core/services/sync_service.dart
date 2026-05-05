import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/local/sync_database.dart';

class SyncService {
  SyncService(this._client);

  final SupabaseClient _client;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _syncing = false;

  void start() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) {
        flush();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> flush() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final results = await Connectivity().checkConnectivity();
      final online = results.any((r) => r != ConnectivityResult.none);
      if (!online) return;

      final items = await SyncDatabase.pendingItems();
      for (final item in items) {
        final tableName = item['table_name'] as String;
        final operation = item['operation'] as String;
        final recordId = item['record_id'] as String?;
        final payload = jsonDecode(item['payload'] as String) as Map<String, dynamic>;

        try {
          switch (operation) {
            case 'insert':
              await _client.from(tableName).insert(payload);
              break;
            case 'update':
              if (recordId != null) {
                await _client.from(tableName).update(payload).eq('id', recordId);
              }
              break;
            case 'delete':
              if (recordId != null) {
                await _client.from(tableName).delete().eq('id', recordId);
              }
              break;
          }
          await SyncDatabase.remove(item['id'] as int);
        } catch (_) {
          // Leave in queue; retry on next flush.
          break;
        }
      }
    } finally {
      _syncing = false;
    }
  }
}
