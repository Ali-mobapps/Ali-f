class InquiryEntity {
  final String id;
  final String userId;
  final String itemId;
  final String itemType;
  final String senderRole;
  final String message;
  final DateTime createdAt;

  const InquiryEntity({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

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
