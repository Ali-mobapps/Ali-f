class PaymentMethodModel {
  final String id;
  final String title;
  final String accountNumber;
  final String accountTitle;
  final String logoUrl;

  PaymentMethodModel({
    required this.id,
    required this.title,
    required this.accountNumber,
    this.accountTitle = 'Dynetix Official',
    required this.logoUrl,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? title,
    String? accountNumber,
    String? accountTitle,
    String? logoUrl,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      title: title ?? this.title,
      accountNumber: accountNumber ?? this.accountNumber,
      accountTitle: accountTitle ?? this.accountTitle,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
