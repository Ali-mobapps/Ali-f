import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sync_provider.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class GoogleDriveSetupScreen extends StatefulWidget {
  const GoogleDriveSetupScreen({super.key});

  @override
  State<GoogleDriveSetupScreen> createState() => _GoogleDriveSetupScreenState();
}

class _GoogleDriveSetupScreenState extends State<GoogleDriveSetupScreen> {
  bool _isConnecting = false;

  Future<void> _handleConnectVault() async {
    setState(() => _isConnecting = true);
    final syncProvider = Provider.of<SyncProvider>(context, listen: false);
    await syncProvider.syncNow();
    if (mounted) {
      setState(() => _isConnecting = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clinical Record Sync'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              );
            },
            child: const Text('Skip', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge & Title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryFixed.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_sync, size: 14, color: AppColors.secondary),
                    SizedBox(width: 4),
                    Text(
                      'PRIVATE VAULT LINK',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect Your Google Drive',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 4),
              const Text(
                'Keep a secure, human-readable backup of your medical records in your personal Google Drive.',
                style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),

              const SizedBox(height: 20),

              // Connected Account Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TARGET ACCOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: AppColors.tertiary),
                            SizedBox(width: 4),
                            Text('Ready to Link', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryFixed,
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ali Reza', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                            Text('ali.reza.health@gmail.com', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Drive Quota', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              Text('14.2 GB available of 15 GB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                            ],
                          ),
                          SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: LinearProgressIndicator(
                              value: 0.05,
                              minHeight: 6,
                              backgroundColor: AppColors.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Folder Structure Preview Card
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
                        Row(
                          children: [
                            Icon(Icons.folder_special, color: AppColors.primary, size: 20),
                            SizedBox(width: 6),
                            Text('Dedicated Directory', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                          ],
                        ),
                        Text('Sandboxed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Google Drive / My Medical History /',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Chip(label: Text('📁 Doctors/'), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                              Chip(label: Text('📁 Visits/'), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                              Chip(label: Text('📁 Prescriptions/'), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                              Chip(label: Text('📁 AppData/'), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Permissions Checklist
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Auto-sync on Wi-Fi only', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Saves cellular bandwidth', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      value: syncProvider.wifiOnly,
                      onChanged: (val) => syncProvider.setWifiOnly(val),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Connect Button
              ElevatedButton(
                onPressed: _isConnecting ? null : _handleConnectVault,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isConnecting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text('Linking Vault to Drive...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_done, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Connect Google Drive & Initialize Vault', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
