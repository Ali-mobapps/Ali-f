class ReportModel {
  final String id;
  final String? visitId;
  final String title;
  final String category; // e.g. "Lab Report", "Radiology / Scans", "Prescription", "Discharge Summary"
  final String filePath;
  final String fileType; // e.g. "pdf", "image", "doc"
  final String fileSize; // e.g. "2.4 MB"
  final DateTime dateAdded;

  ReportModel({
    required this.id,
    this.visitId,
    required this.title,
    required this.category,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visit_id': visitId,
      'title': title,
      'category': category,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'date_added': dateAdded.toIso8601String(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      visitId: map['visit_id'],
      title: map['title'] ?? '',
      category: map['category'] ?? 'Lab Report',
      filePath: map['file_path'] ?? '',
      fileType: map['file_type'] ?? 'pdf',
      fileSize: map['file_size'] ?? '1.0 MB',
      dateAdded: map['date_added'] != null
          ? DateTime.parse(map['date_added'])
          : DateTime.now(),
    );
  }
}
