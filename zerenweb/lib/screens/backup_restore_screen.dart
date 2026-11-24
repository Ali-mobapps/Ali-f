import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drive_backup_provider.dart';
import '../widgets/custom_button.dart';

class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driveProvider = Provider.of<DriveBackupProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2D52),
        title: const Text('Google Drive Backup & Restore', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_sync, size: 80, color: Color(0xFF0F2D52)),
            const SizedBox(height: 16),
            const Text(
              'Secure Cloud Backup',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Safely backup your ZEREN SQLite database (products, cart, orders, profile) to your personal Google Drive and restore it anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Account Status Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Google Account', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        driveProvider.isSignedIn ? (driveProvider.userEmail ?? 'Connected') : 'Not Connected',
                        style: TextStyle(
                          color: driveProvider.isSignedIn ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Last Backup', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(driveProvider.lastBackupTime ?? 'Never', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status Message Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2D52).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0F2D52).withOpacity(0.3)),
              ),
              child: Text(
                'Status: ${driveProvider.statusMessage}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F2D52)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            if (!driveProvider.isSignedIn)
              CustomButton(
                text: 'Sign In with Google',
                isGold: true,
                isLoading: driveProvider.isBusy,
                onPressed: () async {
                  await driveProvider.signIn();
                },
              )
            else ...[
              CustomButton(
                text: 'Backup Database to Drive',
                isGold: true,
                isLoading: driveProvider.isBusy,
                onPressed: () async {
                  final success = await driveProvider.backupDatabase();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Database backup completed!' : 'Backup failed.'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Restore Database from Drive',
                isLoading: driveProvider.isBusy,
                onPressed: () async {
                  // Confirmation dialog before overwrite
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Restore Database?'),
                      content: const Text('Restoring will overwrite your current local database with the backup from Google Drive. A recovery copy will be saved locally. Proceed?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Restore', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final success = await driveProvider.restoreDatabase();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'Database restored successfully!' : 'Restore failed.'),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete Backup from Google Drive', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: driveProvider.isBusy
                    ? null
                    : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Cloud Backup?'),
                            content: const Text('Are you sure you want to permanently delete the ZEREN database backup file from your Google Drive?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final success = await driveProvider.deleteDriveBackup();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success ? 'Cloud backup deleted successfully!' : 'Failed to delete backup.'),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        }
                      },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await driveProvider.signOut();
                },
                child: const Text('Sign Out from Google', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
