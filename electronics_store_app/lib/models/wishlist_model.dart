import 'product_model.dart';

class WishlistModel {
  final int? id;
  final int userId;
  final int productId;
  final ProductModel? product;

  WishlistModel({
    this.id,
    required this.userId,
    required this.productId,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map, {ProductModel? product}) {
    return WishlistModel(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      product: product,
    );
  }
}
