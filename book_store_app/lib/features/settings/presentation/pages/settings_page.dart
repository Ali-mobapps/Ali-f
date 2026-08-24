import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 5,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          _buildSection('Shop Configuration', [
            _buildListTile(Icons.store, 'Shop Name', 'Local Store Manager'),
            _buildListTile(Icons.location_on, 'Address', 'City, Country'),
            _buildListTile(Icons.phone, 'Contact Number', '+92 300 0000000'),
          ]),
          const SizedBox(height: 24),
          _buildSection('Printing & Receipts', [
            _buildListTile(Icons.print, 'Default Printer', 'Not Connected'),
            _buildListTile(Icons.receipt_long, 'Receipt Footer', 'Thank you for your business!'),
          ]),
          const SizedBox(height: 24),
          _buildSection('System', [
            _buildListTile(Icons.backup, 'Database Backup', 'Export CSV Data'),
            _buildListTile(Icons.info_outline, 'About', 'Version 1.0.0'),
            _buildListTile(Icons.logout, 'Logout', 'Sign out of account', color: Colors.red),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blueGrey),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
