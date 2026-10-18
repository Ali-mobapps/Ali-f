import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _cartRepo = CartRepository();
  List<CartItemModel> _items = [];
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  bool get isLoading => _isLoading;

  double get subtotal {
    double total = 0;
    for (var item in _items) {
      if (item.product != null) {
        total += item.product!.price * item.quantity;
      }
    }
    return total;
  }

  double get deliveryFee => _items.isEmpty ? 0.0 : 15.0; // Fixed delivery fee or free over certain amount

  double get total => subtotal + deliveryFee;

  int get totalItemsCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _cartRepo.getCartItems(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching cart: $e');
    }
  }

  Future<void> addToCart(int userId, int productId, int quantity) async {
    try {
      await _cartRepo.addToCart(userId, productId, quantity);
      await fetchCart(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(int userId, int cartItemId, int quantity) async {
    try {
      await _cartRepo.updateQuantity(cartItemId, quantity);
      await fetchCart(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(int userId, int cartItemId) async {
    try {
      await _cartRepo.removeFromCart(cartItemId);
      await fetchCart(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart(int userId) async {
    try {
      await _cartRepo.clearCart(userId);
      _items = [];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
