import 'package:flutter/material.dart';
import '../services/google_drive_service.dart';
import '../services/settings_service.dart';

class SyncProvider extends ChangeNotifier {
  final GoogleDriveService _driveService = GoogleDriveService();
  bool _isSyncing = false;
  bool _wifiOnly = true;
  bool _privacyScreenEnabled = true;

  bool get isSyncing => _isSyncing;
  bool get wifiOnly => _wifiOnly;
  bool get privacyScreenEnabled => _privacyScreenEnabled;

  SyncProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _wifiOnly = await SettingsService.isWifiOnlyEnabled();
    _privacyScreenEnabled = await SettingsService.isPrivacyScreenEnabled();
    notifyListeners();
  }

  Future<void> setWifiOnly(bool val) async {
    _wifiOnly = val;
    await SettingsService.setWifiOnlyEnabled(val);
    notifyListeners();
  }

  Future<void> setPrivacyScreenEnabled(bool val) async {
    _privacyScreenEnabled = val;
    await SettingsService.setPrivacyScreenEnabled(val);
    notifyListeners();
  }

  Future<bool> syncNow() async {
    _isSyncing = true;
    notifyListeners();
    final success = await _driveService.syncNow();
    _isSyncing = false;
    notifyListeners();
    return success;
  }
}
