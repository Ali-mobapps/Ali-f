import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String orderId;
  final String serviceId;
  final String customerId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.customerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, orderId, serviceId, customerId, rating, comment];
}
