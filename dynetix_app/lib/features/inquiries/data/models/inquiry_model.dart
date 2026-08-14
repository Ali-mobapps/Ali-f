import '../../domain/entities/inquiry_entity.dart';

class InquiryModel extends InquiryEntity {
  const InquiryModel({
    required super.id,
    required super.userId,
    required super.itemId,
    required super.itemType,
    required super.senderRole,
    required super.message,
    required super.createdAt,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json, String id) {
    return InquiryModel(
      id: id,
      userId: json['user_id'] ?? '',
      itemId: json['item_id'] ?? '',
      itemType: json['item_type'] ?? 'service',
      senderRole: json['sender_role'] ?? 'customer',
      message: json['message'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'item_id': itemId,
      'item_type': itemType,
      'sender_role': senderRole,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
