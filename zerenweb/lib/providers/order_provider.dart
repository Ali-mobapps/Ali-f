import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../database/database_helper.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await DatabaseHelper.instance.getOrders();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<int?> placeOrder({
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required double totalAmount,
    required List<CartItem> cartItems,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nowStr = DateTime.now().toIso8601String();
      final order = Order(
        orderDate: nowStr,
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        customerName: customerName,
        customerPhone: customerPhone,
        paymentMethod: 'Cash on Delivery',
        orderStatus: 'Placed',
      );

      final orderId = await DatabaseHelper.instance.placeOrder(order, cartItems);
      await fetchOrders();
      _isLoading = false;
      notifyListeners();
      return orderId;
    } catch (e) {
      debugPrint('Error placing order: $e');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
