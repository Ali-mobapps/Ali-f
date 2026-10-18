import '../database/database_helper.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> createOrder({
    required int userId,
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required String paymentMethod,
    required double deliveryFee,
    required List<CartItemModel> cartItems,
  }) async {
    final db = await _dbHelper.database;
    String orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}';

    await db.transaction((txn) async {
      double subtotal = 0;
      for (var item in cartItems) {
        if (item.product == null) throw Exception('Product details missing in cart');
        
        // Check stock
        final productResult = await txn.query(
          'products',
          columns: ['stock', 'price'],
          where: 'id = ?',
          whereArgs: [item.productId],
        );

        if (productResult.isEmpty) throw Exception('Product not found');
        int currentStock = productResult.first['stock'] as int;
        double currentPrice = (productResult.first['price'] as num).toDouble();

        if (currentStock < item.quantity) {
          throw Exception('Insufficient stock for ${item.product!.name}');
        }

        subtotal += currentPrice * item.quantity;

        // Reduce stock
        await txn.update(
          'products',
          {'stock': currentStock - item.quantity},
          where: 'id = ?',
          whereArgs: [item.productId],
        );
      }

      double totalAmount = subtotal + deliveryFee;

      // Insert Order
      final orderId = await txn.insert('orders', {
        'order_number': orderNumber,
        'user_id': userId,
        'total_amount': totalAmount,
        'delivery_fee': deliveryFee,
        'status': 'Pending',
        'payment_method': paymentMethod,
        'payment_status': paymentMethod == 'cash_on_delivery' ? 'Pending' : 'Paid',
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'delivery_address': deliveryAddress,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Insert Order Items (snapshots)
      for (var item in cartItems) {
        await txn.insert('order_items', {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.product!.name,
          'price': item.product!.price,
          'quantity': item.quantity,
          'image_url': item.product!.imageUrl,
        });
      }

      // Clear Cart
      await txn.delete(
        'cart_items',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    });

    return orderNumber;
  }

  Future<List<OrderModel>> getOrders({int? userId, bool isAdmin = false}) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> orderMaps;

    if (isAdmin) {
      orderMaps = await db.query('orders', orderBy: 'created_at DESC');
    } else {
      orderMaps = await db.query(
        'orders',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
    }

    List<OrderModel> orders = [];
    for (var oMap in orderMaps) {
      final orderId = oMap['id'] as int;
      final itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      final items = itemMaps.map((im) => OrderItemModel.fromMap(im)).toList();
      orders.add(OrderModel.fromMap(oMap, items: items));
    }

    return orders;
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final db = await _dbHelper.database;
    await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
