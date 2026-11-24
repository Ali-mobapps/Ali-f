import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../database/database_helper.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => _items.isEmpty ? 0.0 : 250.0; // PKR 250 delivery fee

  double get totalAmount => subtotal + (_items.isEmpty ? 0.0 : deliveryFee);

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await DatabaseHelper.instance.getCartItems();
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(int productId, double price, {int quantity = 1}) async {
    await DatabaseHelper.instance.addToCart(productId, quantity, price);
    await fetchCart();
  }

  Future<void> updateQuantity(int cartId, int quantity) async {
    await DatabaseHelper.instance.updateCartQuantity(cartId, quantity);
    await fetchCart();
  }

  Future<void> removeItem(int cartId) async {
    await DatabaseHelper.instance.removeFromCart(cartId);
    await fetchCart();
  }

  Future<void> clearCart() async {
    await DatabaseHelper.instance.clearCart();
    await fetchCart();
  }
}
