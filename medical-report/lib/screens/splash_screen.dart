import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'google_sign_in_screen.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.34;
  String _statusLabel = "Securing local database...";
  String _statusDetail = "AES-256 Key Handshake";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startInitSequence();
  }

  void _startInitSequence() {
    int step = 0;
    final states = [
      {'pct': 0.34, 'label': "Securing local database...", 'detail': "AES-256 Key Handshake"},
      {'pct': 0.68, 'label': "Verifying biometrics enclave...", 'detail': "Hardware Secure Element"},
      {'pct': 0.92, 'label': "Syncing encrypted health history...", 'detail': "Differential P2P Sync"},
      {'pct': 1.0, 'label': "Vault unlocked securely.", 'detail': "Ready to view"}
    ];

    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      step++;
      if (step < states.length) {
        if (mounted) {
          setState(() {
            _progress = states[step]['pct'] as double;
            _statusLabel = states[step]['label'] as String;
            _statusDetail = states[step]['detail'] as String;
          });
        }
      } else {
        _timer?.cancel();
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GoogleSignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: AppColors.tertiary),
                        SizedBox(width: 6),
                        Text(
                          'HIPAA READY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.verified_user, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'v2.4 Core',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),

              // Center Logo & Vault Diagnostics
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Shield Emblem Stack
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.health_and_safety,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 12,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.surfaceContainerLowest,
                          child: Icon(Icons.lock, size: 16, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'My Medical History',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your medical records, organized and privately held.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Diagnostics Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _statusLabel,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 6,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shield, size: 14, color: AppColors.tertiary),
                                const SizedBox(width: 4),
                                Text(
                                  _statusDetail,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'ID: 8F2A-VAULT',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Footer Privacy Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 16, color: AppColors.tertiary),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Zero-Knowledge Encryption • Client-Side Private Vault',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
