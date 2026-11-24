class OrderItem {
  final int? orderItemId;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_item_id': orderItemId,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderItemId: map['order_item_id'] as int?,
      orderId: map['order_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      quantity: map['quantity'] as int,
      unitPrice: (map['unit_price'] as num).toDouble(),
    );
  }

  double get totalPrice => quantity * unitPrice;
}
