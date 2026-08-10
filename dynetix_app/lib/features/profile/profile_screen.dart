import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final bool isAdmin;

  const ProfileScreen({
    super.key,
    required this.userEmail,
    this.isAdmin = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Dynetix Mobile'),
        content: const Text(
          'Dynetix App is a complete platform providing professional tech services, courses, development, and business management tools.\n\nVersion: 2.0.0\nDeveloped for Dynetix Enterprise.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Navigates back to the root (Role Selection or Login)
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isAdmin ? 'Admin Profile & Settings' : 'Customer Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                  child: Icon(
                    widget.isAdmin ? Icons.admin_panel_settings : Icons.person,
                    size: 50,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.isAdmin ? 'Dynetix Admin' : 'Dynetix Customer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.userEmail,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Settings & Preferences',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          const SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
                  title: const Text('Dark Mode'),
                  value: _isDarkMode,
                  onChanged: (val) {
                    setState(() {
                      _isDarkMode = val;
                    });
                    // Yahan aap app ki theme change ka logic laga sakte hain
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(_isDarkMode
                              ? 'Dark Mode Enabled'
                              : 'Light Mode Enabled')),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary:
                      const Icon(Icons.notifications, color: Colors.indigo),
                  title: const Text('Push Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    setState(() {
                      _notificationsEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'More Information',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          const SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.indigo),
                  title: const Text('About App'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.support_agent, color: Colors.indigo),
                  title: const Text('Customer Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Contact support at support@dynetix.com')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
