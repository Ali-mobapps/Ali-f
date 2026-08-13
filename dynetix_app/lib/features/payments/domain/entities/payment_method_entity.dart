class PaymentMethodEntity {
  final String id;
  final String name;
  final String accountNumber;
  final String? accountTitle;
  final String? logoUrl;
  final bool isActive;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.accountTitle,
    this.logoUrl,
    this.isActive = true,
  });
}
