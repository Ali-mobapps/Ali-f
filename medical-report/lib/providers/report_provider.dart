import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/database_helper.dart';

class ReportProvider extends ChangeNotifier {
  List<MedicalReportModel> _reports = [];
  bool _isLoading = false;

  List<MedicalReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  ReportProvider() {
    loadReports();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    notifyListeners();
    _reports = await DatabaseHelper.instance.getReports();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReport(MedicalReportModel report) async {
    await DatabaseHelper.instance.insertReport(report);
    await loadReports();
  }
}
