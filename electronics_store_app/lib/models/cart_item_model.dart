import 'product_model.dart';

class CartItemModel {
  final int? id;
  final int userId;
  final int productId;
  int quantity;
  final ProductModel? product; // Joined for UI display

  CartItemModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map, {ProductModel? product}) {
    return CartItemModel(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      product: product,
    );
  }

  CartItemModel copyWith({
    int? id,
    int? userId,
    int? productId,
    int? quantity,
    ProductModel? product,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
