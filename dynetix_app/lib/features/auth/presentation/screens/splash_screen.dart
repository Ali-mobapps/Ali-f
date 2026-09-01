import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'role_selection_screen.dart';
import '../../../customer/presentation/screens/customer_dashboard_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';

import '../../../../core/l10n/language_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  void _navigateBasedOnAuth(AuthState state) {
    if (state is AuthAuthenticated) {
      if (state.user.role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()));
      }
    } else if (state is AuthUnauthenticated || state is AuthError) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Wait for the animation and then navigate
        Timer(const Duration(seconds: 2), () => _navigateBasedOnAuth(state));
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DynetixLogo(size: 140, showGlow: true),
                const SizedBox(height: 32),
                const Text(
                  'DYNETIX',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.watch<LanguageCubit>().t('excellence'),
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 3,
                    color: AppColors.textDisabled,
                  ),
                ),
                const SizedBox(height: 60),
                const SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.surface,
                    color: AppColors.primary,
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
