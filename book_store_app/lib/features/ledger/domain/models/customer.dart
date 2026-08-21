class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final double outstandingBalance;
  final DateTime lastTransactionDate;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.outstandingBalance,
    required this.lastTransactionDate,
  });
}
