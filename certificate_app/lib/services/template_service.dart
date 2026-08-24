import 'dart:convert';
import 'package:sqflite/sqflite.dart' as sql;
import '../core/database_helper.dart';

class TemplateService {
  final _dbHelper = DatabaseHelper.instance;

  Future<void> saveTemplate(String templateId, Map<String, dynamic> config) async {
    final db = await _dbHelper.database;
    await db.insert(
      'templates',
      {
        'id': templateId,
        'config': jsonEncode(config),
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getTemplate(String templateId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'templates',
      where: 'id = ?',
      whereArgs: [templateId],
    );

    if (maps.isNotEmpty) {
      return jsonDecode(maps.first['config'] as String) as Map<String, dynamic>;
    }
    return null;
  }
}
