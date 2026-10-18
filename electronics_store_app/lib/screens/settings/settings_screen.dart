import 'package:flutter/material.dart';
import '../backup/backup_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive order status updates and promos'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode (UI Theme)'),
            subtitle: const Text('Enable dark theme appearance'),
            value: _darkModeEnabled,
            onChanged: (val) {
              setState(() {
                _darkModeEnabled = val;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme preference saved locally')),
              );
            },
          ),
          const Divider(height: 32),

          const Text(
            'Data & Security',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.cloud_sync, color: Color(0xFF2563EB)),
            title: const Text('Google Drive Backup & Restore'),
            subtitle: const Text('Securely backup local SQLite database'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BackupScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage, color: Color(0xFF2563EB)),
            title: const Text('Local SQLite Storage'),
            subtitle: const Text('Database: electronics_store.db (Local)'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('SQLite Database Info'),
                  content: const Text(
                    'ElectroStore Pro uses local SQLite (`sqflite`) for lightning-fast offline access, storing users, products, cart items, wishlists, and orders securely on your device.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 32),

          const Text(
            'About Project',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.info_outline, color: Color(0xFF2563EB)),
            title: Text('ElectroStore Pro - Midterm Project'),
            subtitle: Text('Version 1.0.0+1\nFlutter & Dart • Material 3 • SQLite'),
          ),
        ],
      ),
    );
  }
}
