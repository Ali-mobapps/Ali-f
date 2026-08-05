// File path: lib/features/auth/presentation/pages/profile_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/features/auth/presentation/pages/login_page.dart';
import 'package:dynetix_app/features/settings/presentation/pages/settings_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String _language = "English";
  bool _isNotificationsEnabled = true;
  bool _isDarkMode = true;
  Uint8List? _webImageBytes; // Web ke liye bytes

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        var bytes = await image.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          if (AppDatabase.currentUser != null) {
            AppDatabase.currentUser!['webImageBytes'] = bytes;
          }
        });
      } else {
        setState(() {
          if (AppDatabase.currentUser != null) {
            AppDatabase.currentUser!['imagePath'] = image.path;
          }
        });
      }
    }
  }

  // Account Information Dialog
  void _showAccountInfoDialog(String name, String email, bool isAdmin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Account Information', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Role: ${isAdmin ? "Admin" : "User"}', style: const TextStyle(color: Colors.greenAccent)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // Security Dialog
  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Security Settings', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock_reset, color: Color(0xFF0052CC)),
              title: const Text('Change Password', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset link sent to your email.')),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.fingerprint, color: Color(0xFF0052CC)),
              title: Text('Biometric Login', style: TextStyle(color: Colors.white)),
              trailing: Switch(value: true, onChanged: null),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // Preferences Dialog
  void _showPreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          title: const Text('Preferences', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Dark Theme', style: TextStyle(color: Colors.white)),
                value: _isDarkMode,
                onChanged: (val) {
                  setDialogState(() => _isDarkMode = val);
                  setState(() => _isDarkMode = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  // Notification Settings Dialog
  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          title: const Text('Notification Settings', style: TextStyle(color: Colors.white)),
          content: SwitchListTile(
            title: const Text('Enable Push Notifications', style: TextStyle(color: Colors.white)),
            value: _isNotificationsEnabled,
            onChanged: (val) {
              setDialogState(() => _isNotificationsEnabled = val);
              setState(() => _isNotificationsEnabled = val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  // Language Selection Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Select Language', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English', style: TextStyle(color: Colors.white)),
              trailing: _language == 'English' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() => _language = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Urdu (اردو)', style: TextStyle(color: Colors.white)),
              trailing: _language == 'Urdu' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() => _language = 'Urdu');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Help & Support Dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
        content: const Text(
          'For any queries, please email us at support@dynetix.com or visit our help center.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // About Dynetix Dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('About Dynetix', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Dynetix App v1.0.0\nYour ultimate task and finance management companion.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = AppDatabase.currentUser ?? {};
    final String name = user['name'] ?? 'Admin Dynetix';
    final String email = user['email'] ?? 'dynetix.info@gmail.com';
    final bool isAdmin = user['isAdmin'] ?? true;
    final String? imagePath = user['imagePath'];
    final Uint8List? webBytes = user['webImageBytes'] ?? _webImageBytes;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Header Info with Image Picker
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: webBytes != null
                            ? MemoryImage(webBytes)
                            : (imagePath != null ? FileImage(File(imagePath)) as ImageProvider : null),
                        child: (webBytes == null && imagePath == null)
                            ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'A',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0052CC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(isAdmin ? 'Role: Admin' : 'Role: User', style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Options List
            _buildProfileMenuItem(Icons.person_outline, 'Account Information', () => _showAccountInfoDialog(name, email, isAdmin)),
            _buildProfileMenuItem(Icons.lock_outline, 'Security', _showSecurityDialog, trailingText: 'Secure'),
            _buildProfileMenuItem(Icons.tune, 'Preferences', _showPreferencesDialog),
            _buildProfileMenuItem(Icons.notifications_outlined, 'Notification Settings', _showNotificationSettingsDialog),
            _buildProfileMenuItem(Icons.language, 'Language', _showLanguageDialog, trailingText: _language),
            _buildProfileMenuItem(Icons.help_outline, 'Help & Support', _showHelpDialog),
            _buildProfileMenuItem(Icons.info_outline, 'About Dynetix', _showAboutDialog),
            const SizedBox(height: 12),

            // Logout Button
            _buildProfileMenuItem(Icons.logout, 'Logout', () {
              AppDatabase.currentUser = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap, {String? trailingText, bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isLogout ? Colors.red : const Color(0xFF0052CC)),
        title: Text(
          title,
          style: TextStyle(color: isLogout ? Colors.red : Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (trailingText != null) const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: isLogout ? Colors.red : Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}