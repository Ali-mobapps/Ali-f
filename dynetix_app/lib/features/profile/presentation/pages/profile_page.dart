// File path: lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              _showFeatureMessage(context, 'Settings opened');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF1D1E33),
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ali Hassan',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ali.hassan@dynetix.com',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0052CC)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      _showFeatureMessage(context, 'Edit Profile clicked');
                    },
                    child: const Text('Edit Profile', style: TextStyle(color: Color(0xFF0052CC))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Options List with functional onTap handlers
            _buildProfileOption(context, Icons.person_outline, 'Account Information', '', () {
              _showFeatureMessage(context, 'Account Information details');
            }),
            _buildProfileOption(context, Icons.lock_outline, 'Security', 'Secure', () {
              _showFeatureMessage(context, 'Security settings: Account is Secure');
            }),
            _buildProfileOption(context, Icons.tune, 'Preferences', '', () {
              _showFeatureMessage(context, 'Preferences opened');
            }),
            _buildProfileOption(context, Icons.notifications_none, 'Notification Settings', '', () {
              _showFeatureMessage(context, 'Notification Settings opened');
            }),
            _buildProfileOption(context, Icons.language, 'Language', 'English', () {
              _showFeatureMessage(context, 'Language changed to English');
            }),
            _buildProfileOption(context, Icons.help_outline, 'Help & Support', '', () {
              _showFeatureMessage(context, 'Help & Support opened');
            }),
            _buildProfileOption(context, Icons.info_outline, 'About Dynetix', '', () {
              _showFeatureMessage(context, 'Dynetix Mobile App v1.0.0');
            }),
            const SizedBox(height: 20),

            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                _showFeatureMessage(context, 'Logged out successfully');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title, String trailingText, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText.isNotEmpty)
              Text(
                trailingText,
                style: TextStyle(
                  color: trailingText == 'Secure' ? Colors.green : Colors.grey,
                  fontSize: 13,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showFeatureMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF0052CC),
      ),
    );
  }
}