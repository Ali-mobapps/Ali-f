import 'dart:convert';
import 'vital_signs_model.dart';
import 'prescription_model.dart';
import 'report_model.dart';

class MedicalVisitModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorHospital;
  final String? doctorAvatarUrl;
  final DateTime visitDate;
  final String timeStr;
  final String consultationType; // "In-Person", "Teleconsultation"
  final String reason;
  final List<String> symptoms;
  final String diagnosis;
  final VitalSignsModel vitals;
  final List<PrescriptionModel> prescriptions;
  final List<ReportModel> reports;
  final DateTime? followUpDate;
  final String? notes;
  final bool isSynced;

  MedicalVisitModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorHospital,
    this.doctorAvatarUrl,
    required this.visitDate,
    required this.timeStr,
    required this.consultationType,
    required this.reason,
    required this.symptoms,
    required this.diagnosis,
    required this.vitals,
    required this.prescriptions,
    required this.reports,
    this.followUpDate,
    this.notes,
    this.isSynced = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_specialty': doctorSpecialty,
      'doctor_hospital': doctorHospital,
      'doctor_avatar_url': doctorAvatarUrl,
      'visit_date': visitDate.toIso8601String(),
      'time_str': timeStr,
      'consultation_type': consultationType,
      'reason': reason,
      'symptoms_json': jsonEncode(symptoms),
      'diagnosis': diagnosis,
      'bp': vitals.bloodPressure,
      'heart_rate': vitals.heartRate,
      'temperature': vitals.temperature,
      'weight': vitals.weight,
      'blood_sugar': vitals.bloodSugar,
      'spo2': vitals.spo2,
      'follow_up_date': followUpDate?.toIso8601String(),
      'notes': notes,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory MedicalVisitModel.fromMap(
    Map<String, dynamic> map, {
    List<PrescriptionModel> prescriptions = const [],
    List<ReportModel> reports = const [],
  }) {
    List<String> parsedSymptoms = [];
    if (map['symptoms_json'] != null) {
      try {
        final List<dynamic> list = jsonDecode(map['symptoms_json']);
        parsedSymptoms = list.map((e) => e.toString()).toList();
      } catch (_) {}
    }

    return MedicalVisitModel(
      id: map['id'] ?? '',
      doctorId: map['doctor_id'] ?? '',
      doctorName: map['doctor_name'] ?? '',
      doctorSpecialty: map['doctor_specialty'] ?? '',
      doctorHospital: map['doctor_hospital'] ?? '',
      doctorAvatarUrl: map['doctor_avatar_url'],
      visitDate: map['visit_date'] != null
          ? DateTime.parse(map['visit_date'])
          : DateTime.now(),
      timeStr: map['time_str'] ?? '',
      consultationType: map['consultation_type'] ?? 'In-Person',
      reason: map['reason'] ?? '',
      symptoms: parsedSymptoms,
      diagnosis: map['diagnosis'] ?? '',
      vitals: VitalSignsModel(
        bloodPressure: map['bp'],
        heartRate: map['heart_rate'],
        temperature: map['temperature'],
        weight: map['weight'],
        bloodSugar: map['blood_sugar'],
        spo2: map['spo2'],
      ),
      prescriptions: prescriptions,
      reports: reports,
      followUpDate: map['follow_up_date'] != null
          ? DateTime.parse(map['follow_up_date'])
          : null,
      notes: map['notes'],
      isSynced: (map['is_synced'] ?? 1) == 1,
    );
  }
}
