import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerId,
    super.serviceId,
    required super.status,
    required super.price,
    required super.serviceTitle,
    required super.createdAt,
    super.paymentStatus,
    super.paymentScreenshot,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerId: json['customer_id'],
      serviceId: json['service_id']?.toString(),
      status: json['status'],
      price: (json['price'] as num).toDouble(),
      serviceTitle: json['service_title'],
      createdAt: DateTime.parse(json['created_at']),
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paymentScreenshot: json['payment_screenshot'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'service_id': serviceId != null ? int.tryParse(serviceId!) : null,
      'status': status,
      'price': price,
      'service_title': serviceTitle,
      'payment_status': paymentStatus,
      'payment_screenshot': paymentScreenshot,
    };
  }
}
