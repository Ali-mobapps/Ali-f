class MedicalReportModel {
  final String id;
  final String title;
  final String category; // 'blood', 'xray', 'mri', 'ultrasound', 'rx'
  final String doctorName;
  final String hospitalName;
  final String reportDate;
  final String statusBadge; // 'Normal', 'Clear', 'Pending'
  final String summaryMetrics;
  final String? filePath;
  final String fileType; // 'PDF', 'DICOM', 'JPG'
  final String drivePath;
  final double fileSizeMb;

  MedicalReportModel({
    required this.id,
    required this.title,
    required this.category,
    required this.doctorName,
    required this.hospitalName,
    required this.reportDate,
    required this.statusBadge,
    required this.summaryMetrics,
    this.filePath,
    required this.fileType,
    required this.drivePath,
    this.fileSizeMb = 1.2,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'reportDate': reportDate,
      'statusBadge': statusBadge,
      'summaryMetrics': summaryMetrics,
      'filePath': filePath,
      'fileType': fileType,
      'drivePath': drivePath,
      'fileSizeMb': fileSizeMb,
    };
  }

  factory MedicalReportModel.fromMap(Map<String, dynamic> map) {
    return MedicalReportModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'blood',
      doctorName: map['doctorName'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      reportDate: map['reportDate'] ?? '',
      statusBadge: map['statusBadge'] ?? 'Normal',
      summaryMetrics: map['summaryMetrics'] ?? '',
      filePath: map['filePath'],
      fileType: map['fileType'] ?? 'PDF',
      drivePath: map['drivePath'] ?? '',
      fileSizeMb: (map['fileSizeMb'] as num?)?.toDouble() ?? 1.2,
    );
  }
}
