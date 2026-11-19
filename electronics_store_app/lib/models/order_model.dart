class OrderItemModel {
  final int? id;
  final int orderId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      imageUrl: map['image_url'] ?? '',
    );
  }
}

class OrderModel {
  final int? id;
  final String orderNumber;
  final int userId;
  final double totalAmount;
  final double deliveryFee;
  final String status; // Pending, Confirmed, Shipped, Delivered, Cancelled
  final String paymentMethod; // 'demo_card', 'cash_on_delivery', etc.
  final String paymentStatus; // 'Paid', 'Pending', 'Failed'
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String trackingNote;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.userId,
    required this.totalAmount,
    required this.deliveryFee,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.trackingNote,
    required this.createdAt,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'total_amount': totalAmount,
      'delivery_fee': deliveryFee,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'tracking_note': trackingNote,
      'created_at': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, {List<OrderItemModel>? items}) {
    return OrderModel(
      id: map['id'],
      orderNumber: map['order_number'],
      userId: map['user_id'],
      totalAmount: (map['total_amount'] as num).toDouble(),
      deliveryFee: (map['delivery_fee'] as num).toDouble(),
      status: map['status'],
      paymentMethod: map['payment_method'],
      paymentStatus: map['payment_status'],
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
      deliveryAddress: map['delivery_address'],
      trackingNote: map['tracking_note'] ?? 'Order placed successfully. Preparing for dispatch.',
      createdAt: map['created_at'],
      items: items ?? [],
    );
  }
}
