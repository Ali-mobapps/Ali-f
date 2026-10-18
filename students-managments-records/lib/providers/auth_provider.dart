import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  SharedPreferences? _prefs;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkSession();
  }

  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> _checkSession() async {
    try {
      final prefs = await _getPrefs;
      final userId = prefs.getInt(AppConstants.prefLoggedInUserId);

      if (userId != null) {
        _currentUser = await _authRepo.getUserById(userId);
        notifyListeners();
      }
    } catch (_) {
      _currentUser = null;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepo.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (_currentUser?.id != null) {
        final prefs = await _getPrefs;
        await prefs.setInt(AppConstants.prefLoggedInUserId, _currentUser!.id!);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepo.loginUser(
        email: email,
        password: password,
      );

      if (_currentUser?.id != null) {
        final prefs = await _getPrefs;
        await prefs.setInt(AppConstants.prefLoggedInUserId, _currentUser!.id!);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? newPassword,
  }) async {
    if (_currentUser == null || _currentUser!.id == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepo.updateProfile(
        id: _currentUser!.id!,
        name: name,
        email: email,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await _getPrefs;
    await prefs.remove(AppConstants.prefLoggedInUserId);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
