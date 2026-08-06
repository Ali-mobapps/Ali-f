// File path: lib/features/auth/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/features/dashboard/presentation/pages/main_wrapper.dart';
import 'package:dynetix_app/features/auth/presentation/pages/login_page.dart';
import 'package:dynetix_app/features/auth/presentation/pages/signup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // Professional Google Account Selector Dialog
  void _showGoogleAccountPicker() {
    final List<Map<String, String>> savedEmails = [
      {'name': 'Ali Hassan', 'email': 'alihassan6236007@gmail.com', 'avatar': 'A'},
      {'name': 'Ali Yaseen', 'email': 'ay9805782@gmail.com', 'avatar': 'A'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1E33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.g_mobiledata, color: Colors.blue, size: 36),
                  SizedBox(width: 8),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose an account to continue to Dynetix App',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12),

              // Email accounts list
              ListView.builder(
                shrinkWrap: true,
                itemCount: savedEmails.length,
                itemBuilder: (context, index) {
                  final account = savedEmails[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0052CC),
                      child: Text(account['avatar']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(account['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(account['email']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      _processGoogleLogin(account['email']!, account['name']!);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Professional Loading and Login Process
  void _processGoogleLogin(String email, String name) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0052CC)),
      ),
    );

    await Future.delayed(const Duration(seconds: 1)); // Simulate secure login

    AppDatabase.loginUser(email, 'google_secure_pass', name);

    if (mounted) {
      Navigator.pop(context); // Close loading
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    }
  }

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
              Image.asset(
                'assets/images/logo.png',
                height: 180,
                width: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'Dynetix App',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Ultimate Business & Admin Solution',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0052CC)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  child: const Text('Create Account (Register)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              // Google Sign-In Professional Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: _showGoogleAccountPicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}