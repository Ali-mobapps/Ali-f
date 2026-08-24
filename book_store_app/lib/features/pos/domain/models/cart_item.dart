import '../../../inventory/models/product_model.dart';

class CartItem {
  final Product item;
  int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.salePrice * quantity;
}
