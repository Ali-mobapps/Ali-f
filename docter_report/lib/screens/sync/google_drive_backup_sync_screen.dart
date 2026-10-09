import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sync_provider.dart';

class GoogleDriveBackupSyncScreen extends StatelessWidget {
  const GoogleDriveBackupSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncProvider>(context);
    final syncStatus = syncProvider.syncStatus;

    final lastSyncStr =
        '${syncStatus.lastSyncedAt.hour}:${syncStatus.lastSyncedAt.minute.toString().padLeft(2, '0')} PM Today';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Google Drive Account Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant, width: 0.8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAoWIJ0cPFqJuAnCKM9Ku-XkoNFbCEMKj_63U5ivnoWZkOGckSIhAD6XXfD6tpIgYFbxPucwqR9LaAYMZhFwn6pbx1EwuIUF-JKX19SpERFxrNKu53bz8019MXMZIDi9y6R5WELri33oCbPp2XJWKsfKvxQnqRLzNEiDfYRTTbP8firHDkg0vxY4bg6b_LOkEsA6tGaZWf-NwHdID6JHThXo3OcnFmcP2LD3MKgtmKUZsbxjNy6_Imh',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Connected Google Drive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.outline,
                        ),
                      ),
                      Text(
                        syncStatus.accountEmail,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Vault Storage: ${syncStatus.cloudStorageUsedMB.toStringAsFixed(1)} MB (${syncStatus.totalCloudFilesCount} files)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.cloud_done, color: AppColors.tertiary, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sync Status & Trigger Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          syncStatus.isSyncing
                              ? Icons.sync
                              : Icons.check_circle_rounded,
                          color: syncStatus.isSyncing
                              ? AppColors.warning
                              : AppColors.tertiary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          syncStatus.isSyncing
                              ? 'Syncing with Drive...'
                              : 'Cloud Vault Up To Date',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lastSyncStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (syncStatus.isSyncing)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(color: AppColors.primary),
                  ),

                ElevatedButton.icon(
                  onPressed: syncStatus.isSyncing
                      ? null
                      : () => syncProvider.syncNow(),
                  icon: const Icon(Icons.sync, color: Colors.white),
                  label: const Text(
                    'Sync Now',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Settings Options
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant, width: 0.8),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Automatic Background Sync',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  subtitle: const Text(
                    'Automatically sync new medical visits and PDF scans when on Wi-Fi',
                    style: TextStyle(fontSize: 12, color: AppColors.outline),
                  ),
                  value: syncStatus.isAutoSyncEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => syncProvider.toggleAutoSync(val),
                ),
                const Divider(height: 1, color: AppColors.outlineVariant),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.restore_page_outlined,
                      color: AppColors.primary),
                  title: const Text(
                    'Restore Medical Records from Drive',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Download and restore your encrypted database backup',
                    style: TextStyle(fontSize: 12, color: AppColors.outline),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Database is up to date. Restore complete!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
