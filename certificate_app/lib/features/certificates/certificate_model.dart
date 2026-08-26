class Certificate {
  final String id;
  final String recipientName;
  final String recipientEmail;
  final String courseTitle;
  final String description;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String status; // 'Issued', 'Revoked', 'Pending'
  final String templateId;
  final String? signatureBase64;

  Certificate({
    required this.id,
    required this.recipientName,
    required this.recipientEmail,
    required this.courseTitle,
    required this.description,
    required this.issueDate,
    this.expiryDate,
    required this.status,
    required this.templateId,
    this.signatureBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'recipientEmail': recipientEmail,
      'courseTitle': courseTitle,
      'description': description,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status,
      'templateId': templateId,
      'signatureBase64': signatureBase64,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'] ?? '',
      recipientName: map['recipientName'] ?? '',
      recipientEmail: map['recipientEmail'] ?? '',
      courseTitle: map['courseTitle'] ?? '',
      description: map['description'] ?? '',
      issueDate: DateTime.parse(map['issueDate']),
      expiryDate: map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      status: map['status'] ?? 'Issued',
      templateId: map['templateId'] ?? 'default',
      signatureBase64: map['signatureBase64'],
    );
  }
}
