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
    super.deliverables,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id'] ?? '',
      serviceId: json['service_id']?.toString(),
      status: json['status'] ?? 'pending',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      serviceTitle: json['service_title'] ?? 'Unknown Service',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paymentScreenshot: json['payment_screenshot'],
      deliverables: (json['deliverables'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'status': status,
      'price': price,
      'service_title': serviceTitle,
      'payment_status': paymentStatus,
      'payment_screenshot': paymentScreenshot,
      'deliverables': deliverables,
      'created_at': createdAt.toIso8601String(),
    };

    if (serviceId != null) {
      // Try to send as integer if possible, otherwise as string (UUID)
      final intId = int.tryParse(serviceId!);
      if (intId != null) {
        data['service_id'] = intId;
      } else {
        data['service_id'] = serviceId;
      }
    }

    return data;
  }
}
