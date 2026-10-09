import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../services/database_helper.dart';

class DoctorProvider extends ChangeNotifier {
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;

  DoctorProvider() {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    _isLoading = true;
    notifyListeners();
    _doctors = await DatabaseHelper.instance.getDoctors();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDoctor(DoctorModel doctor) async {
    await DatabaseHelper.instance.insertDoctor(doctor);
    await loadDoctors();
  }

  DoctorModel? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
