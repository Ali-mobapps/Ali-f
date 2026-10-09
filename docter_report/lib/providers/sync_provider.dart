import 'package:flutter/material.dart';
import '../models/sync_status_model.dart';

class SyncProvider extends ChangeNotifier {
  SyncStatusModel _syncStatus = SyncStatusModel(
    isSynced: true,
    lastSyncedAt: DateTime.now().subtract(const Duration(minutes: 12)),
    accountEmail: 'tariq.health@gmail.com',
    totalCloudFilesCount: 24,
    cloudStorageUsedMB: 48.6,
    isAutoSyncEnabled: true,
    isSyncing: false,
  );

  SyncStatusModel get syncStatus => _syncStatus;

  Future<void> syncNow() async {
    if (_syncStatus.isSyncing) return;

    _syncStatus = _syncStatus.copyWith(isSyncing: true, isSynced: false);
    notifyListeners();

    // Simulate Google Drive API upload/sync latency
    await Future.delayed(const Duration(seconds: 2));

    _syncStatus = _syncStatus.copyWith(
      isSyncing: false,
      isSynced: true,
      lastSyncedAt: DateTime.now(),
      totalCloudFilesCount: _syncStatus.totalCloudFilesCount + 1,
      cloudStorageUsedMB: _syncStatus.cloudStorageUsedMB + 1.2,
    );
    notifyListeners();
  }

  void toggleAutoSync(bool value) {
    _syncStatus = _syncStatus.copyWith(isAutoSyncEnabled: value);
    notifyListeners();
  }
}
