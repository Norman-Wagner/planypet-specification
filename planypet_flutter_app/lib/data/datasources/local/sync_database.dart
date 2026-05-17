import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SyncDatabase {
  static const _dbName = 'planypet_sync.db';
  static const _dbVersion = 1;

  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pending_sync (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        operation TEXT NOT NULL,
        record_id TEXT,
        payload TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE feeding_log (
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        family_id TEXT NOT NULL,
        fed_at TEXT NOT NULL,
        food_name TEXT,
        portion_grams INTEGER,
        notes TEXT,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        pet_id TEXT,
        family_id TEXT NOT NULL,
        title TEXT NOT NULL,
        due_at TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        completed_at TEXT,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  static Future<int> enqueue({
    required String tableName,
    required String operation,
    String? recordId,
    required Map<String, dynamic> payload,
  }) async {
    final db = await instance();
    return db.insert('pending_sync', {
      'table_name': tableName,
      'operation': operation,
      'record_id': recordId,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> pendingItems() async {
    final db = await instance();
    return db.query('pending_sync', orderBy: 'created_at ASC');
  }

  static Future<void> remove(int id) async {
    final db = await instance();
    await db.delete('pending_sync', where: 'id = ?', whereArgs: [id]);
  }
}
