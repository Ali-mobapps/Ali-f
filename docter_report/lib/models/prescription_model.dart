class PrescriptionModel {
  final String id;
  final String visitId;
  final String medicineName;
  final String dosage;      // e.g. "500 mg"
  final String frequency;   // e.g. "Twice daily (After meals)"
  final String duration;    // e.g. "7 Days"
  final bool isActive;
  final String? notes;

  PrescriptionModel({
    required this.id,
    required this.visitId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.isActive = true,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visit_id': visitId,
      'medicine_name': medicineName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'is_active': isActive ? 1 : 0,
      'notes': notes,
    };
  }

  factory PrescriptionModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionModel(
      id: map['id'] ?? '',
      visitId: map['visit_id'] ?? '',
      medicineName: map['medicine_name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      duration: map['duration'] ?? '',
      isActive: (map['is_active'] ?? 1) == 1,
      notes: map['notes'],
    );
  }
}
