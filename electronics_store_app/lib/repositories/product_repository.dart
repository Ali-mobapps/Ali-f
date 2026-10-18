import '../database/database_helper.dart';
import '../models/product_model.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    String? sortBy, // 'price_asc', 'price_desc', 'rating', 'newest'
  }) async {
    final db = await _dbHelper.database;

    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (category != null && category != 'All') {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereClause += ' AND (name LIKE ? OR description LIKE ?)';
      whereArgs.add('%${searchQuery.trim()}%');
      whereArgs.add('%${searchQuery.trim()}%');
    }

    String orderBy = 'created_at DESC';
    if (sortBy == 'price_asc') {
      orderBy = 'price ASC';
    } else if (sortBy == 'price_desc') {
      orderBy = 'price DESC';
    } else if (sortBy == 'rating') {
      orderBy = 'rating DESC';
    }

    final results = await db.query(
      'products',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return results.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<List<String>> getCategories() async {
    final db = await _dbHelper.database;
    final results = await db.query('categories');
    return results.map((map) => map['name'] as String).toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return ProductModel.fromMap(results.first);
    }
    return null;
  }

  Future<int> addProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    return await db.insert('products', product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      {
        ...product.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
