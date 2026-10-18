import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utilities/date_formatter.dart';
import '../../providers/backup_restore_provider.dart';
import '../../providers/student_provider.dart';
import '../../services/google_drive_service.dart';
import '../../widgets/custom_button.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BackupRestoreProvider>(context, listen: false);
      if (provider.isConnected) {
        provider.loadDriveBackups();
      }
    });
  }

  Future<void> _handleRestore(GoogleDriveBackupFile backup) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Database Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backup File: ${backup.name}'),
            const SizedBox(height: 12),
            const Text(
              'Choose how you want to restore student records:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, 'merge'),
            child: const Text('Merge Records'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, 'replace'),
            child: const Text('Replace All'),
          ),
        ],
      ),
    );

    if (choice == null || choice == 'cancel' || !mounted) return;

    final replaceExisting = choice == 'replace';

    final backupProvider = Provider.of<BackupRestoreProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);

    final messenger = ScaffoldMessenger.of(context);
    final success = await backupProvider.restoreBackupFromDrive(
      backup.id,
      replaceExisting: replaceExisting,
    );

    if (success && mounted) {
      await studentProvider.loadStudents();
      await studentProvider.loadDashboardStats();

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Database restored successfully! All records refreshed.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backupProvider = Provider.of<BackupRestoreProvider>(context);

    final lastBackup = backupProvider.lastBackupDate != null
        ? DateFormatter.parseDate(backupProvider.lastBackupDate!)
        : null;

    final formattedLastBackup =
        lastBackup != null ? DateFormatter.formatDateTime(lastBackup) : 'Never';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Backup & Restore'),
        actions: [
          if (backupProvider.isConnected)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Drive Backups',
              onPressed: () => backupProvider.loadDriveBackups(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Status Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backupProvider.isConnected
                                ? AppColors.success.withOpacity(0.15)
                                : Colors.grey.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            backupProvider.isConnected ? Icons.cloud_done : Icons.cloud_off,
                            color: backupProvider.isConnected ? AppColors.success : Colors.grey,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                backupProvider.isConnected
                                    ? 'Connected to Google Drive'
                                    : 'Not Connected to Google Drive',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                backupProvider.isConnected
                                    ? (backupProvider.userGoogleEmail ?? 'Signed in')
                                    : 'Sign in to sync database backups to Google Cloud',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (!backupProvider.isConnected)
                      CustomButton(
                        text: 'Connect Google Account',
                        icon: Icons.account_circle,
                        isLoading: backupProvider.isLoading,
                        onPressed: () => backupProvider.connectGoogleDrive(),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () => backupProvider.disconnectGoogleDrive(),
                        icon: const Icon(Icons.logout),
                        label: const Text('Disconnect Google Drive'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Backup Actions Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Cloud Backup',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Exports local SQLite students database and uploads securely to Google Drive.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.history, size: 18, color: AppColors.primaryLightBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Last Backup: $formattedLastBackup',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Backup Database Now',
                      icon: Icons.cloud_upload,
                      isLoading: backupProvider.isLoading,
                      onPressed: backupProvider.isConnected
                          ? () => backupProvider.createBackupToDrive()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (backupProvider.statusMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        backupProvider.statusMessage!,
                        style: const TextStyle(color: AppColors.info, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (backupProvider.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        backupProvider.errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Available Cloud Backups
            const Text(
              'Available Backups on Google Drive',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (!backupProvider.isConnected)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text('Connect Google Drive to view and restore cloud backups'),
                      ],
                    ),
                  ),
                ),
              )
            else if (backupProvider.driveBackups.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.folder_zip_outlined, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'No Google Drive backups found.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap "Backup Database Now" above to create your first cloud backup.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: backupProvider.driveBackups.length,
                itemBuilder: (context, index) {
                  final backup = backupProvider.driveBackups[index];
                  final createdStr = backup.createdTime != null
                      ? DateFormatter.formatDateTime(backup.createdTime!)
                      : 'Unknown Date';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.lightBlueBg,
                        child: Icon(Icons.file_present_rounded, color: AppColors.primaryNavy),
                      ),
                      title: Text(
                        backup.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(createdStr, style: const TextStyle(fontSize: 12)),
                      trailing: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 36),
                        ),
                        onPressed: () => _handleRestore(backup),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Restore'),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
