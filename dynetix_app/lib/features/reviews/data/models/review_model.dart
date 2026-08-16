import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.orderId,
    required super.serviceId,
    required super.customerId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      orderId: json['order_id'],
      serviceId: json['service_id'].toString(),
      customerId: json['customer_id'],
      rating: json['rating'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'service_id': int.parse(serviceId),
      'customer_id': customerId,
      'rating': rating,
      'comment': comment,
    };
  }
}
