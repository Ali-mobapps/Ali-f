import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/sync_provider.dart';
import 'home/home_dashboard_screen.dart';
import 'timeline/medical_history_timeline_screen.dart';
import 'vault/reports_scans_vault_screen.dart';
import 'sync/google_drive_backup_sync_screen.dart';
import 'wizard/add_medical_visit_wizard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    MedicalHistoryTimelineScreen(),
    ReportsScansVaultScreen(),
    GoogleDriveBackupSyncScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncProvider>(context);
    final syncStatus = syncProvider.syncStatus;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Logo / App Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_hospital_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'My Medical History',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Clinical Clarity Vault',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Cloud Synced Badge
                  GestureDetector(
                    onTap: () => setState(() => _currentIndex = 3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: syncStatus.isSyncing
                                  ? AppColors.warning
                                  : AppColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            syncStatus.isSyncing
                                ? Icons.sync
                                : Icons.cloud_done_rounded,
                            size: 15,
                            color: syncStatus.isSyncing
                                ? AppColors.warning
                                : AppColors.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            syncStatus.isSyncing ? 'Syncing...' : 'Synced',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: syncStatus.isSyncing
                                  ? AppColors.warning
                                  : AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // User Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.outlineVariant, width: 1),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAoWIJ0cPFqJuAnCKM9Ku-XkoNFbCEMKj_63U5ivnoWZkOGckSIhAD6XXfD6tpIgYFbxPucwqR9LaAYMZhFwn6pbx1EwuIUF-JKX19SpERFxrNKu53bz8019MXMZIDi9y6R5WELri33oCbPp2XJWKsfKvxQnqRLzNEiDfYRTTbP8firHDkg0vxY4bg6b_LOkEsA6tGaZWf-NwHdID6JHThXo3OcnFmcP2LD3MKgtmKUZsbxjNy6_Imh',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicalVisitWizardScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
        label: const Text(
          'Add Visit',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.outline,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline_outlined),
              activeIcon: Icon(Icons.timeline_rounded),
              label: 'Timeline',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder_rounded),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined),
              activeIcon: Icon(Icons.cloud_rounded),
              label: 'Drive Sync',
            ),
          ],
        ),
      ),
    );
  }
}
