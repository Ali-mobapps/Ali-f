import 'product_model.dart';

class CartItem {
  final int? cartId;
  final int productId;
  int quantity;
  final double unitPrice;
  Product? product; // Joined product details for UI display

  CartItem({
    this.cartId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map['cart_id'] as int?,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      unitPrice: (map['unit_price'] as num).toDouble(),
    );
  }

  double get totalPrice => quantity * unitPrice;
}
