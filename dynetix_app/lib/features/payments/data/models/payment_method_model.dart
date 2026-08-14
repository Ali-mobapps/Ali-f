import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    required super.accountNumber,
    super.accountTitle,
    super.logoUrl,
    super.isActive = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json, String id) {
    return PaymentMethodModel(
      id: id,
      name: json['name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountTitle: json['account_title'],
      logoUrl: json['logo_url'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'account_number': accountNumber,
      'account_title': accountTitle,
      'logo_url': logoUrl,
      'is_active': isActive,
    };
  }
}
