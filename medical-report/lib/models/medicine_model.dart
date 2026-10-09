class MedicineModel {
  final String id;
  final String visitId;
  final String name;
  final String? genericName;
  final String dosage; // e.g. "500 mg", "10ml"
  final String frequency; // e.g. "2x / day", "TDS"
  final String duration; // e.g. "5 Days"
  final String mealInstruction; // e.g. "After Meal", "Before Bed"
  final String? timingNotes; // e.g. "Morning • Night"
  final String? warningNotes; // e.g. "Causes Drowsiness"

  MedicineModel({
    required this.id,
    required this.visitId,
    required this.name,
    this.genericName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.mealInstruction,
    this.timingNotes,
    this.warningNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitId': visitId,
      'name': name,
      'genericName': genericName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'mealInstruction': mealInstruction,
      'timingNotes': timingNotes,
      'warningNotes': warningNotes,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'] ?? '',
      visitId: map['visitId'] ?? '',
      name: map['name'] ?? '',
      genericName: map['genericName'],
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      duration: map['duration'] ?? '',
      mealInstruction: map['mealInstruction'] ?? '',
      timingNotes: map['timingNotes'],
      warningNotes: map['warningNotes'],
    );
  }
}
