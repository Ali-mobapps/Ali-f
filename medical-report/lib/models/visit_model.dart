import 'medicine_model.dart';
import 'lab_test_model.dart';

class MedicalVisitModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String hospitalName;
  final String visitDate;
  final String symptoms;
  final String diagnosis;
  final String? doctorNotes;
  final String? followUpDate;
  final String? prescriptionPdfPath;
  final List<MedicineModel> medicines;
  final List<LabTestModel> labTests;
  final String syncStatus; // 'Synced', 'Pending', 'Archived'

  MedicalVisitModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.hospitalName,
    required this.visitDate,
    required this.symptoms,
    required this.diagnosis,
    this.doctorNotes,
    this.followUpDate,
    this.prescriptionPdfPath,
    this.medicines = const [],
    this.labTests = const [],
    this.syncStatus = 'Synced',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': specialty,
      'hospitalName': hospitalName,
      'visitDate': visitDate,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'doctorNotes': doctorNotes,
      'followUpDate': followUpDate,
      'prescriptionPdfPath': prescriptionPdfPath,
      'syncStatus': syncStatus,
    };
  }

  factory MedicalVisitModel.fromMap(
    Map<String, dynamic> map, {
    List<MedicineModel> medicines = const [],
    List<LabTestModel> labTests = const [],
  }) {
    return MedicalVisitModel(
      id: map['id'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialty: map['specialty'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      visitDate: map['visitDate'] ?? '',
      symptoms: map['symptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      doctorNotes: map['doctorNotes'],
      followUpDate: map['followUpDate'],
      prescriptionPdfPath: map['prescriptionPdfPath'],
      syncStatus: map['syncStatus'] ?? 'Synced',
      medicines: medicines,
      labTests: labTests,
    );
  }

  MedicalVisitModel copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? specialty,
    String? hospitalName,
    String? visitDate,
    String? symptoms,
    String? diagnosis,
    String? doctorNotes,
    String? followUpDate,
    String? prescriptionPdfPath,
    List<MedicineModel>? medicines,
    List<LabTestModel>? labTests,
    String? syncStatus,
  }) {
    return MedicalVisitModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      hospitalName: hospitalName ?? this.hospitalName,
      visitDate: visitDate ?? this.visitDate,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      followUpDate: followUpDate ?? this.followUpDate,
      prescriptionPdfPath: prescriptionPdfPath ?? this.prescriptionPdfPath,
      medicines: medicines ?? this.medicines,
      labTests: labTests ?? this.labTests,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
