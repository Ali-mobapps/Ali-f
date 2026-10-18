import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepo = OrderRepository();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders({int? userId, bool isAdmin = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderRepo.getOrders(userId: userId, isAdmin: isAdmin);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching orders: $e');
    }
  }

  Future<String> placeOrder({
    required int userId,
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required String paymentMethod,
    required double deliveryFee,
    required List<CartItemModel> cartItems,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orderNumber = await _orderRepo.createOrder(
        userId: userId,
        customerName: customerName,
        customerPhone: customerPhone,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        deliveryFee: deliveryFee,
        cartItems: cartItems,
      );
      _isLoading = false;
      notifyListeners();
      return orderNumber;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus, int userId, bool isAdmin) async {
    try {
      await _orderRepo.updateOrderStatus(orderId, newStatus);
      await fetchOrders(userId: userId, isAdmin: isAdmin);
    } catch (e) {
      rethrow;
    }
  }
}
