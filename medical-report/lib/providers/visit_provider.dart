import 'package:flutter/material.dart';
import '../models/visit_model.dart';
import '../services/database_helper.dart';

class VisitProvider extends ChangeNotifier {
  List<MedicalVisitModel> _visits = [];
  bool _isLoading = false;

  List<MedicalVisitModel> get visits => _visits;
  bool get isLoading => _isLoading;

  VisitProvider() {
    loadVisits();
  }

  Future<void> loadVisits() async {
    _isLoading = true;
    notifyListeners();
    _visits = await DatabaseHelper.instance.getVisits();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addVisit(MedicalVisitModel visit) async {
    await DatabaseHelper.instance.insertVisit(visit);
    await loadVisits();
  }

  List<MedicalVisitModel> getVisitsForDoctor(String doctorId) {
    return _visits.where((v) => v.doctorId == doctorId).toList();
  }
}
