import 'package:flutter/material.dart';
import '../../../../core/theme/vip_theme.dart';
import 'admin_login_screen.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 120, errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 120, color: VIPTheme.primaryGold)),
            const SizedBox(height: 30),
            const Text(
              "DYNETIX PORTAL",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2, color: VIPTheme.primaryGold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen())),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.admin_panel_settings), SizedBox(width: 10), Text("ADMIN LOGIN")],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: VIPTheme.primaryGold, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.person, color: VIPTheme.primaryGold), SizedBox(width: 10), Text("CUSTOMER LOGIN", style: TextStyle(color: VIPTheme.primaryGold))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
