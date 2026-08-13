import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About Dynetix')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DynetixLogo(size: 100),
              const SizedBox(height: 24),
              const Text('DYNETIX', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 16),
              const Text(
                'Dynetix is a premium technology company dedicated to simplifying digital services and empowering professionals through elite academy courses.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const Spacer(),
              const Text('Version 1.0.0', style: TextStyle(color: AppColors.textDisabled)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
