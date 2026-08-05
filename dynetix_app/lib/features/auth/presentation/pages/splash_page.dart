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
              // Logo with background blending to hide white square if any
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0A0E21),
                  BlendMode.multiply,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
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
              // Register / Create Account Button
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
              // Google Sign-In Option (Working Database Integration)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: () {
                    // Automatically login/create user via Google simulation
                    AppDatabase.loginUser('google_user@dynetix.com', 'google_pass', 'Google User');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainWrapper()),
                    );
                  },
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