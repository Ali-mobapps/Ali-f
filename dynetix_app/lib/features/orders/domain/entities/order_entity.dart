import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String customerId;
  final String? serviceId;
  final String status;
  final double price;
  final String serviceTitle;
  final DateTime createdAt;
  final String paymentStatus; // 'unpaid', 'pending_verification', 'paid'
  final String? paymentScreenshot;
  final List<String> deliverables;

  const OrderEntity({
    required this.id,
    required this.customerId,
    this.serviceId,
    required this.status,
    required this.price,
    required this.serviceTitle,
    required this.createdAt,
    this.paymentStatus = 'unpaid',
    this.paymentScreenshot,
    this.deliverables = const [],
  });

  OrderEntity copyWith({
    String? status,
    String? paymentStatus,
    String? paymentScreenshot,
    List<String>? deliverables,
  }) {
    return OrderEntity(
      id: id,
      customerId: customerId,
      serviceId: serviceId,
      status: status ?? this.status,
      price: price,
      serviceTitle: serviceTitle,
      createdAt: createdAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentScreenshot: paymentScreenshot ?? this.paymentScreenshot,
      deliverables: deliverables ?? this.deliverables,
    );
  }

  @override
  List<Object?> get props => [id, customerId, status, serviceTitle, paymentStatus, paymentScreenshot, deliverables];
}
