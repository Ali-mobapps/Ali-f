import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required String id,
    required String itemTitle,
    required double amount,
    required String status,
    required DateTime timestamp,
  }) : super(
    id: id,
    itemTitle: itemTitle,
    amount: amount,
    status: status,
    timestamp: timestamp,
  );

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      itemTitle: json['itemTitle'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemTitle': itemTitle,
      'amount': amount,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}