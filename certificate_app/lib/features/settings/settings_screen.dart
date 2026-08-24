import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CertifyProTopBar(title: 'System Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Account Management',
              children: [
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: 'Administrator Profile',
                  subtitle: 'admin@certifypro.com',
                  trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
                ),
                const Divider(),
                _buildSettingTile(
                  icon: Icons.lock_reset,
                  title: 'Change Master Password',
                  subtitle: 'Update your access credentials',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Application Preferences',
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Issuance Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Notify via email when a certificate is issued'),
                  value: true,
                  onChanged: (v) {},
                  activeThumbColor: CertifyProTheme.primary,
                ),
                const Divider(),
                _buildSettingTile(
                  icon: Icons.backup_outlined,
                  title: 'Local Database Export',
                  subtitle: 'Backup your cert_ledger.db file',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 48),
            Center(
              child: TextButton.icon(
                onPressed: () => AuthService().signOut(),
                icon: const Icon(Icons.logout, color: CertifyProTheme.error),
                label: const Text('Sign Out Securely', style: TextStyle(color: CertifyProTheme.error)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: Text('CertifyPro Local v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CertifyProTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1, color: CertifyProTheme.accentGold)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: CertifyProTheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}
