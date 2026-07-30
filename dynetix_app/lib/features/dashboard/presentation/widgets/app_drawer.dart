import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121A26), // Dark mode look matching screenshot
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF121A26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.layers, color: Color(0xFF0052CC), size: 28),
                    SizedBox(width: 10),
                    Text(
                      'DYNETIX',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', true, () {}),
          _buildDrawerItem(Icons.task_alt, 'My Tasks', false, () {}),
          _buildDrawerItem(Icons.payment, 'Payments', false, () {}),
          _buildDrawerItem(Icons.receipt_long, 'Invoices', false, () {}),
          _buildDrawerItemWithBadge(Icons.notifications_outlined, 'Notifications', '3', () {}),
          _buildDrawerItem(Icons.person_outline, 'Profile', false, () {}),
          _buildDrawerItem(Icons.settings_outlined, 'Settings', false, () {}),
          const Divider(color: Colors.white24, thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(Icons.logout, 'Logout', false, () {}, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF0052CC) : (isLogout ? Colors.red : Colors.white70)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0052CC) : (isLogout ? Colors.red : Colors.white70),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF0052CC).withOpacity(0.15),
      onTap: onTap,
    );
  }

  Widget _buildDrawerItemWithBadge(IconData icon, String title, String badgeCount, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          badgeCount,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: onTap,
    );
  }
}