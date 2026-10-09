import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sync_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'google_sign_in_screen.dart';

class GoogleDriveSyncSecurityScreen extends StatefulWidget {
  const GoogleDriveSyncSecurityScreen({super.key});

  @override
  State<GoogleDriveSyncSecurityScreen> createState() => _GoogleDriveSyncSecurityScreenState();
}

class _GoogleDriveSyncSecurityScreenState extends State<GoogleDriveSyncSecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vault & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Vault Trust Badge Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.secondaryFixed,
                          child: Icon(Icons.cloud_sync, color: AppColors.primary, size: 20),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vault & Cloud Backup', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                            Text('Zero-Knowledge AES-256 Protocol', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.lock, size: 12, color: AppColors.onTertiaryFixed),
                          SizedBox(width: 2),
                          Text('Secure', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onTertiaryFixed)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Account & Logout Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryFixed,
                      child: Text('AR', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ali Reza', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                          Text('ali.reza.health@gmail.com', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text('Are you sure you want to sign out of Google Vault?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Provider.of<AuthProvider>(context, listen: false).signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const GoogleSignInScreen()),
                                  );
                                },
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout, size: 16, color: AppColors.error),
                      label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.errorContainer),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Offline Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.offline_pin, color: AppColors.primary, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Offline Ready & Resilient: All records are cached locally via encrypted SQLite.',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Google Drive Account & Sync Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Google Drive', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                        Text('Connected & Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('ali.reza.health@gmail.com', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: syncProvider.isSyncing
                          ? null
                          : () async {
                              final success = await syncProvider.syncNow();
                              if (context.mounted && success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Vault synced successfully to Google Drive!')),
                                );
                              }
                            },
                      icon: syncProvider.isSyncing
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.sync, size: 18),
                      label: Text(syncProvider.isSyncing ? 'Syncing to Google Drive...' : 'Sync Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Auto-sync on Wi-Fi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Sync seamlessly in background', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                      value: syncProvider.wifiOnly,
                      onChanged: (val) => syncProvider.setWifiOnly(val),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Drive Folder Architecture
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Drive Folder Architecture', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        '📁 My Medical History/\n  ├─ 📁 Doctors/\n  ├─ 📁 Visits/\n  └─ 📁 AppData/',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.5, color: AppColors.onSurface),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // App Security & Vault Settings
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('App Security & Vault', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Privacy Screen', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Blur preview on app switcher', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                      value: syncProvider.privacyScreenEnabled,
                      onChanged: (val) => syncProvider.setPrivacyScreenEnabled(val),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Disaster Recovery
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Export & Recovery', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exporting complete medical history archive...')),
                        );
                      },
                      icon: const Icon(Icons.file_download, size: 18),
                      label: const Text('Export Complete Medical History'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
