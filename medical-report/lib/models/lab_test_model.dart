class LabTestModel {
  final String id;
  final String visitId;
  final String testName;
  final String labName;
  final String testDate;
  final String resultStatus; // 'Normal', 'Pending', 'Abnormal', 'Clear'
  final String? summary;
  final String? fileUrl;

  LabTestModel({
    required this.id,
    required this.visitId,
    required this.testName,
    required this.labName,
    required this.testDate,
    required this.resultStatus,
    this.summary,
    this.fileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitId': visitId,
      'testName': testName,
      'labName': labName,
      'testDate': testDate,
      'resultStatus': resultStatus,
      'summary': summary,
      'fileUrl': fileUrl,
    };
  }

  factory LabTestModel.fromMap(Map<String, dynamic> map) {
    return LabTestModel(
      id: map['id'] ?? '',
      visitId: map['visitId'] ?? '',
      testName: map['testName'] ?? '',
      labName: map['labName'] ?? '',
      testDate: map['testDate'] ?? '',
      resultStatus: map['resultStatus'] ?? 'Normal',
      summary: map['summary'],
      fileUrl: map['fileUrl'],
    );
  }
}
