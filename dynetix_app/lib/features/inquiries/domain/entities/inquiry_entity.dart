class InquiryEntity {
  final String id;
  final String customerEmail;
  final String message;
  final DateTime timestamp;

  const InquiryEntity({
    required this.id,
    required this.customerEmail,
    required this.message,
    required this.timestamp,
  });
}
