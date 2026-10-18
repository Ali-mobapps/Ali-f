import '../database/database_helper.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CartItemModel>> getCartItems(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT c.*, p.name, p.category, p.description, p.price, p.image_url, p.stock, p.rating, p.created_at, p.updated_at
      FROM cart_items c
      JOIN products p ON c.product_id = p.id
      WHERE c.user_id = ?
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

      return CartItemModel.fromMap(map, product: product);
    }).toList();
  }

  Future<void> addToCart(int userId, int productId, int quantity) async {
    final db = await _dbHelper.database;

    // Check if item already in cart
    final existing = await db.query(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );

    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      final newQty = currentQty + quantity;
      await db.update(
        'cart_items',
        {'quantity': newQty},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('cart_items', {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final db = await _dbHelper.database;
    if (quantity <= 0) {
      await removeFromCart(cartItemId);
    } else {
      await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> clearCart(int userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
