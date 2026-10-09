import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/doctor_model.dart';
import '../models/medical_visit_model.dart';
import '../models/prescription_model.dart';
import '../models/report_model.dart';

class MedicalProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<MedicalVisitModel> _visits = [];
  List<DoctorModel> _doctors = [];
  List<PrescriptionModel> _activePrescriptions = [];
  List<ReportModel> _allReports = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String? _selectedDoctorId;

  List<MedicalVisitModel> get visits => _visits;
  List<DoctorModel> get doctors => _doctors;
  List<PrescriptionModel> get activePrescriptions => _activePrescriptions;
  List<ReportModel> get allReports => _allReports;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String? get selectedDoctorId => _selectedDoctorId;

  // Stats
  int get doctorsCount => _doctors.length;
  int get visitsCount => _visits.length;
  int get activeMedsCount => _activePrescriptions.length;
  int get labReportsCount => _allReports.length;

  MedicalVisitModel? get upcomingFollowUp {
    final now = DateTime.now();
    try {
      final followUps = _visits
          .where((v) => v.followUpDate != null && v.followUpDate!.isAfter(now))
          .toList();
      if (followUps.isEmpty) return null;
      followUps.sort((a, b) => a.followUpDate!.compareTo(b.followUpDate!));
      return followUps.first;
    } catch (_) {
      return null;
    }
  }

  MedicalProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _doctors = await _dbHelper.getAllDoctors();
    _visits = await _dbHelper.getAllVisits(
      searchQuery: _searchQuery,
      categoryFilter: _selectedCategory,
      doctorIdFilter: _selectedDoctorId,
    );
    _activePrescriptions = await _dbHelper.getActivePrescriptions();
    _allReports = await _dbHelper.getAllReports();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterVisits();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _filterVisits();
  }

  void setDoctorFilter(String? doctorId) {
    _selectedDoctorId = doctorId;
    _filterVisits();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedDoctorId = null;
    loadData();
  }

  Future<void> _filterVisits() async {
    _visits = await _dbHelper.getAllVisits(
      searchQuery: _searchQuery,
      categoryFilter: _selectedCategory,
      doctorIdFilter: _selectedDoctorId,
    );
    notifyListeners();
  }

  Future<void> addMedicalVisit(MedicalVisitModel visit) async {
    await _dbHelper.insertVisit(visit);
    await loadData();
  }

  Future<void> deleteMedicalVisit(String id) async {
    await _dbHelper.deleteVisit(id);
    await loadData();
  }

  Future<void> addReport(ReportModel report) async {
    await _dbHelper.insertReport(report);
    await loadData();
  }

  Future<void> deleteReport(String id) async {
    await _dbHelper.deleteReport(id);
    await loadData();
  }
}
