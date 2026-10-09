class SyncStatusModel {
  final bool isSynced;
  final DateTime lastSyncedAt;
  final String accountEmail;
  final int totalCloudFilesCount;
  final double cloudStorageUsedMB;
  final bool isAutoSyncEnabled;
  final bool isSyncing;

  SyncStatusModel({
    required this.isSynced,
    required this.lastSyncedAt,
    required this.accountEmail,
    required this.totalCloudFilesCount,
    required this.cloudStorageUsedMB,
    this.isAutoSyncEnabled = true,
    this.isSyncing = false,
  });

  SyncStatusModel copyWith({
    bool? isSynced,
    DateTime? lastSyncedAt,
    String? accountEmail,
    int? totalCloudFilesCount,
    double? cloudStorageUsedMB,
    bool? isAutoSyncEnabled,
    bool? isSyncing,
  }) {
    return SyncStatusModel(
      isSynced: isSynced ?? this.isSynced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      accountEmail: accountEmail ?? this.accountEmail,
      totalCloudFilesCount: totalCloudFilesCount ?? this.totalCloudFilesCount,
      cloudStorageUsedMB: cloudStorageUsedMB ?? this.cloudStorageUsedMB,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}
