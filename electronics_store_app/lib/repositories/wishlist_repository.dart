import '../database/database_helper.dart';
import '../models/wishlist_model.dart';
import '../models/product_model.dart';

class WishlistRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<WishlistModel>> getWishlist(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT w.*, p.name, p.category, p.description, p.price, p.image_url, p.stock, p.rating, p.created_at, p.updated_at
      FROM wishlists w
      JOIN products p ON w.product_id = p.id
      WHERE w.user_id = ?
    ''', [userId]);

    return results.map((map) {
      final product = ProductModel(
        id: map['product_id'] as int,
        name: map['name'] as String,
        category: map['category'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        imageUrl: map['image_url'] as String,
        stock: map['stock'] as int,
        rating: (map['rating'] as num).toDouble(),
        createdAt: map['created_at'] as String,
        updatedAt: map['updated_at'] as String,
      );

      return WishlistModel.fromMap(map, product: product);
    }).toList();
  }

  Future<bool> isInWishlist(int userId, int productId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'wishlists',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
    return results.isNotEmpty;
  }

  Future<void> toggleWishlist(int userId, int productId) async {
    final db = await _dbHelper.database;
    final existing = await db.query(
      'wishlists',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );

    if (existing.isNotEmpty) {
      await db.delete(
        'wishlists',
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );
    } else {
      await db.insert('wishlists', {
        'user_id': userId,
        'product_id': productId,
      });
    }
  }
}
