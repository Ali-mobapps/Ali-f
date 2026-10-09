import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'google_sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Keep Your Medical History Organized',
      'subtitle': 'Securely archive all your medical records, prescriptions, and lab tests in one private vault.',
      'icon': Icons.folder_special,
      'color': AppColors.primary,
    },
    {
      'title': 'Remember Every Doctor Visit',
      'subtitle': 'Keep track of doctor consultations, diagnoses, prescribed medicines, and follow-up dates.',
      'icon': Icons.event_available,
      'color': AppColors.secondary,
    },
    {
      'title': 'Your Records, Wherever You Need Them',
      'subtitle': 'Seamlessly backup and sync your health records to your personal Google Drive with end-to-end encryption.',
      'icon': Icons.cloud_sync,
      'color': AppColors.tertiary,
    },
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GoogleSignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _getStarted,
            child: const Text('Skip', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: (page['color'] as Color).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 72,
                            color: page['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primary : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Bottom CTA Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
