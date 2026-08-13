import '../../domain/entities/inquiry_entity.dart';

/// Data model for inquiries, extending [InquiryEntity] with JSON serialization.
class InquiryModel extends InquiryEntity {
  /// Creates an [InquiryModel] instance.
  const InquiryModel({
    required super.id,
    required super.userId,
    required super.itemId,
    required super.itemType,
    required super.senderRole,
    required super.message,
    required super.createdAt,
  });

  /// Factory constructor to create an [InquiryModel] from JSON data and a document ID.
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

  /// Converts the [InquiryModel] to a JSON map for storage.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }
}
