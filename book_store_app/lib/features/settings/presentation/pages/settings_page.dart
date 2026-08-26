import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/dashboard_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 5,
      title: 'settings'.tr,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('General Settings', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language / زبان',
            subtitle: Get.locale?.languageCode == 'en' ? 'English (Tap to switch to Urdu)' : 'اردو (انگریزی میں تبدیل کرنے کے لیے تھپتھپائیں)',
            onTap: () {
              if (Get.locale?.languageCode == 'en') {
                Get.updateLocale(const Locale('ur', 'PK'));
              } else {
                Get.updateLocale(const Locale('en', 'US'));
              }
            },
          ),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Theme Mode',
            subtitle: Get.isDarkMode ? 'Dark Mode (Tap for Light)' : 'Light Mode (Tap for Dark)',
            onTap: () {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          _SettingsTile(
            icon: Icons.storefront_outlined,
            title: 'Shop Information',
            subtitle: 'Change name, address, and phone number',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.print_outlined,
            title: 'Printer Configuration',
            subtitle: 'Setup thermal printer via Bluetooth/USB',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.notifications_none_outlined,
            title: 'Low Stock Alerts',
            subtitle: 'Configure threshold for automatic alerts',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Text('Security & Database', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Admin PIN',
            subtitle: 'Secure your dashboard with a new password',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Database Backup',
            subtitle: 'Export data or sync with cloud manually',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Logout from Admin Session'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF0A1931)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
