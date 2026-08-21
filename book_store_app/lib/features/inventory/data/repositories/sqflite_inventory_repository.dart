import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/models/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

class SqfliteInventoryRepository implements InventoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('inventory');
    return List.generate(maps.length, (i) => InventoryItem.fromMap(maps[i]));
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    final db = await _dbHelper.database;
    await db.insert(
      'inventory',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    final db = await _dbHelper.database;
    await db.update(
      'inventory',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
