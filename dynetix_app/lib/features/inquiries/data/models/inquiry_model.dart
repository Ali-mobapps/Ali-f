import '../../domain/entities/inquiry_entity.dart';

class InquiryModel extends InquiryEntity {
  const InquiryModel({
    required String id,
    required String customerEmail,
    required String message,
    required DateTime timestamp,
  }) : super(
          id: id,
          customerEmail: customerEmail,
          message: message,
          timestamp: timestamp,
        );

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerEmail': customerEmail,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
