import 'package:equatable/equatable.dart';

class InquiryEntity extends Equatable {
  final String id;
  final String userId;
  final String itemId; // Service or Course ID
  final String itemType; // 'service' or 'course'
  final String senderRole; // 'customer' or 'admin'
  final String message;
  final DateTime createdAt;
  final bool hiddenFromCustomer;
  final bool hiddenFromAdmin;

  const InquiryEntity({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.senderRole,
    required this.message,
    required this.createdAt,
    this.hiddenFromCustomer = false,
    this.hiddenFromAdmin = false,
  });

  @override
  List<Object?> get props => [id, userId, itemId, senderRole, message, createdAt, hiddenFromCustomer, hiddenFromAdmin];
}
