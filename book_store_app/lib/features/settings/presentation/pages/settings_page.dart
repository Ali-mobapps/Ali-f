import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardLayout(
      selectedIndex: 5,
      child: Center(
        child: Text('Settings Page - General, Printer, and User Management'),
      ),
    );
  }
}
