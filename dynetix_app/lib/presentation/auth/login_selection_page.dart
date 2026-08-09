import 'package:flutter/material.dart';
import 'customer_login_screen.dart';
import 'admin_login_screen.dart';

class LoginSelectionPage extends StatelessWidget {
  const LoginSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.business_center_rounded, size: 100, color: Color(0xFF0052CC)),
              const SizedBox(height: 24),
              const Text(
                'Dynetix Portal',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Select your entry to continue',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              
              _buildSelectionButton(
                context: context,
                title: 'Admin Portal',
                subtitle: 'Manage system & services',
                icon: Icons.admin_panel_settings_rounded,
                color: Colors.amber,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen())),
              ),
              const SizedBox(height: 20),
              
              _buildSelectionButton(
                context: context,
                title: 'Customer Portal',
                subtitle: 'Access courses & services',
                icon: Icons.person_rounded,
                color: const Color(0xFF0052CC),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerLoginScreen())),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}
