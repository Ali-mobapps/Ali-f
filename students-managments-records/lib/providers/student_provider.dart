import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../repositories/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _studentRepo = StudentRepository();

  List<StudentModel> _students = [];
  Map<String, dynamic> _dashboardStats = {
    'total': 0,
    'departments': <String, int>{},
    'semesters': <String, int>{},
    'recent': <StudentModel>[],
  };

  bool _isLoading = false;
  String? _errorMessage;

  // Search & Filter state
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  String _selectedSemester = 'All';
  String _sortBy = 'name'; // 'name', 'roll', 'date'
  bool _sortAscending = true;

  List<StudentModel> get students => _students;
  Map<String, dynamic> get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String get selectedDepartment => _selectedDepartment;
  String get selectedSemester => _selectedSemester;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  StudentProvider() {
    refreshAll();
  }

  /// Fast parallel refresh for students list & stats
  Future<void> refreshAll() async {
    try {
      final results = await Future.wait([
        _studentRepo.getStudents(
          searchQuery: _searchQuery,
          department: _selectedDepartment,
          semester: _selectedSemester,
          sortBy: _sortBy,
          ascending: _sortAscending,
        ),
        _studentRepo.getDashboardStats(),
      ]);

      _students = results[0] as List<StudentModel>;
      _dashboardStats = results[1] as Map<String, dynamic>;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStudents() async {
    try {
      _students = await _studentRepo.getStudents(
        searchQuery: _searchQuery,
        department: _selectedDepartment,
        semester: _selectedSemester,
        sortBy: _sortBy,
        ascending: _sortAscending,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDashboardStats() async {
    try {
      _dashboardStats = await _studentRepo.getDashboardStats();
      notifyListeners();
    } catch (_) {}
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadStudents();
  }

  void setDepartmentFilter(String dept) {
    _selectedDepartment = dept;
    loadStudents();
  }

  void setSemesterFilter(String sem) {
    _selectedSemester = sem;
    loadStudents();
  }

  void setSorting(String field, bool ascending) {
    _sortBy = field;
    _sortAscending = ascending;
    loadStudents();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedDepartment = 'All';
    _selectedSemester = 'All';
    _sortBy = 'name';
    _sortAscending = true;
    loadStudents();
  }

  Future<bool> addStudent(StudentModel student) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentRepo.addStudent(student);
      await refreshAll();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent(StudentModel student) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentRepo.updateStudent(student);
      await refreshAll();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _studentRepo.deleteStudent(id);
      await refreshAll();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
