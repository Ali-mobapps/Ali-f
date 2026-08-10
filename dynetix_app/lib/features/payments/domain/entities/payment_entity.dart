class PaymentEntity {
  final String id;
  final String itemTitle;
  final double amount;
  final String status; // 'Success', 'Pending', 'Failed'
  final DateTime timestamp;

  const PaymentEntity({
    required this.id,
    required this.itemTitle,
    required this.amount,
    required this.status,
    required this.timestamp,
  });
}
