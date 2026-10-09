import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/google_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleAuthService _authService = GoogleAuthService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _user = await _authService.initialize();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    _user = await _authService.signInWithGoogle();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
