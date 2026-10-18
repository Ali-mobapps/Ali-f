import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../database/database_helper.dart';
import '../services/google_drive_service.dart';

class BackupRestoreProvider with ChangeNotifier {
  final GoogleDriveService _driveService = GoogleDriveService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  bool _isConnected = false;
  String? _userGoogleEmail;
  bool _isLoading = false;
  String? _statusMessage;
  String? _errorMessage;
  String? _lastBackupDate;

  List<GoogleDriveBackupFile> _driveBackups = [];

  bool get isConnected => _isConnected;
  String? get userGoogleEmail => _userGoogleEmail;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;
  String? get errorMessage => _errorMessage;
  String? get lastBackupDate => _lastBackupDate;
  List<GoogleDriveBackupFile> get driveBackups => _driveBackups;

  BackupRestoreProvider() {
    _initAndCheckAccount();
  }

  Future<void> _initAndCheckAccount() async {
    final prefs = await SharedPreferences.getInstance();
    _lastBackupDate = prefs.getString(AppConstants.prefLastBackupDate);

    final account = await _driveService.signInSilently();
    if (account != null) {
      _isConnected = true;
      _userGoogleEmail = account.email;
      notifyListeners();
      loadDriveBackups();
    } else {
      notifyListeners();
    }
  }

  Future<bool> connectGoogleDrive() async {
    _isLoading = true;
    _errorMessage = null;
    _statusMessage = 'Connecting to Google Drive...';
    notifyListeners();

    try {
      final account = await _driveService.signIn();
      if (account != null) {
        _isConnected = true;
        _userGoogleEmail = account.email;
        _statusMessage = 'Connected as ${account.email}';
        _isLoading = false;
        notifyListeners();
        await loadDriveBackups();
        return true;
      } else {
        _errorMessage = 'Google Sign-In was cancelled.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to connect Google Drive: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnectGoogleDrive() async {
    await _driveService.signOut();
    _isConnected = false;
    _userGoogleEmail = null;
    _driveBackups = [];
    _statusMessage = 'Disconnected from Google Drive';
    notifyListeners();
  }

  Future<void> loadDriveBackups() async {
    if (!_isConnected) return;

    _isLoading = true;
    _errorMessage = null;
    _statusMessage = 'Fetching backups from Google Drive...';
    notifyListeners();

    try {
      _driveBackups = await _driveService.listBackups();
      _statusMessage = 'Found ${_driveBackups.length} backup(s)';
    } catch (e) {
      _errorMessage = 'Failed to load backups: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBackupToDrive() async {
    if (!_isConnected) {
      _errorMessage = 'Please connect your Google Drive account first.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _statusMessage = 'Preparing database backup payload...';
    notifyListeners();

    try {
      final jsonPayload = await _dbHelper.exportBackupData();
      _statusMessage = 'Uploading backup to Google Drive...';
      notifyListeners();

      await _driveService.uploadBackup(jsonPayload);

      final nowIso = DateTime.now().toIso8601String();
      _lastBackupDate = nowIso;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefLastBackupDate, nowIso);

      _statusMessage = 'Backup created and uploaded successfully!';
      _isLoading = false;
      notifyListeners();

      await loadDriveBackups();
      return true;
    } catch (e) {
      _errorMessage = 'Backup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> restoreBackupFromDrive(String fileId, {required bool replaceExisting}) async {
    _isLoading = true;
    _errorMessage = null;
    _statusMessage = 'Downloading backup file from Google Drive...';
    notifyListeners();

    try {
      final jsonString = await _driveService.downloadBackup(fileId);

      _statusMessage = 'Restoring database records...';
      notifyListeners();

      await _dbHelper.restoreBackupData(jsonString, replaceExisting: replaceExisting);

      _statusMessage = 'Database restored successfully!';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Restore failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearStatus() {
    _errorMessage = null;
    _statusMessage = null;
    notifyListeners();
  }
}
