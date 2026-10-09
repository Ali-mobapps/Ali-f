import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'google_drive_setup_screen.dart';
import 'main_navigation_screen.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isAuthenticating = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isAuthenticating = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithGoogle();
    if (mounted) {
      setState(() => _isAuthenticating = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GoogleDriveSetupScreen()),
      );
    }
  }

  void _handleSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign In'),
        actions: [
          TextButton(
            onPressed: _handleSkip,
            child: const Text('Skip', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Header Icon & Title
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'My Medical History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sign in to securely manage and sync your medical records.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // Private by Design Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Private by Design',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.lock, size: 10, color: AppColors.tertiaryFixed),
                                    SizedBox(width: 2),
                                    Text(
                                      'AES-256',
                                      style: TextStyle(fontSize: 10, color: AppColors.tertiaryFixed, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your health records are client-side encrypted before leaving your phone and stored exclusively in your personal Google Drive storage.',
                            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Active Google Vault Selector (Clickable to pick Google Account)
              InkWell(
                onTap: _isAuthenticating ? null : _handleGoogleSignIn,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryFixed,
                        child: Text('AR', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ali.reza.health@gmail.com',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Tap to select Google Account',
                              style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.secondary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Continue with Google Button
              ElevatedButton(
                onPressed: _isAuthenticating ? null : _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  foregroundColor: AppColors.onSurface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: _isAuthenticating
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                            height: 20,
                            width: 20,
                            errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 32),

              // Trust Points
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cloud_sync, size: 16, color: AppColors.secondary),
                              SizedBox(width: 4),
                              Text('Self-Hosted', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('Data remains in your Google Drive', style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified, size: 16, color: AppColors.tertiaryContainer),
                              SizedBox(width: 4),
                              Text('Zero Telemetry', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.tertiaryContainer)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('No tracking or data collection', style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
