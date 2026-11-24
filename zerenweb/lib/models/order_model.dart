import 'order_item_model.dart';

class Order {
  final int? orderId;
  final int? userId;
  final String orderDate;
  final double totalAmount;
  final String deliveryAddress;
  final String customerName;
  final String customerPhone;
  final String paymentMethod;
  final String orderStatus;
  List<OrderItem>? items;

  Order({
    this.orderId,
    this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.customerName,
    required this.customerPhone,
    this.paymentMethod = 'Cash on Delivery',
    this.orderStatus = 'Placed',
    this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'order_date': orderDate,
      'total_amount': totalAmount,
      'delivery_address': deliveryAddress,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'payment_method': paymentMethod,
      'order_status': orderStatus,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['order_id'] as int?,
      userId: map['user_id'] as int?,
      orderDate: map['order_date'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      deliveryAddress: map['delivery_address'] as String,
      customerName: map['customer_name'] as String,
      customerPhone: map['customer_phone'] as String,
      paymentMethod: map['payment_method'] as String? ?? 'Cash on Delivery',
      orderStatus: map['order_status'] as String? ?? 'Placed',
    );
  }
}
