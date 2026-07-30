// File path: lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = true;
  bool _pushNotifications = true;
  bool _biometricLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Appearance', style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Use dark theme across the app', style: TextStyle(color: Colors.grey, fontSize: 12)),
              secondary: const Icon(Icons.dark_mode, color: Colors.white70),
              activeColor: const Color(0xFF0052CC),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),

          const Text('Security & Notifications', style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Receive alerts for tasks and payments', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  secondary: const Icon(Icons.notifications_active, color: Colors.white70),
                  activeColor: const Color(0xFF0052CC),
                  value: _pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                SwitchListTile(
                  title: const Text('Biometric Login', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Use fingerprint or Face ID to login', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  secondary: const Icon(Icons.fingerprint, color: Colors.white70),
                  activeColor: const Color(0xFF0052CC),
                  value: _biometricLogin,
                  onChanged: (bool value) {
                    setState(() {
                      _biometricLogin = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('More Options', style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Colors.white70),
                  title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: Colors.white70),
                  title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                  onTap: () {},
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.white70),
                  title: const Text('App Version', style: TextStyle(color: Colors.white)),
                  trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}