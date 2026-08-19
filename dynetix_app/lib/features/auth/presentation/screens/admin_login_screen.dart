import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -200,
            left: MediaQuery.of(context).size.width / 2 - 400,
            child: Container(
              width: 800, height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.primary.withValues(alpha: 0.05), Colors.transparent]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: const EdgeInsets.all(20),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const DynetixLogo(size: 80, showGlow: false),
                        const SizedBox(height: 24),
                        const Text('ADMIN ACCESS', style: TextStyle(letterSpacing: 6, color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 12)),
                        const SizedBox(height: 48),
                        GlassPanel(
                          padding: 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 32),
                              _buildLabel('Email Address'),
                              TextField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: const InputDecoration(hintText: 'Enter Admin Email', prefixIcon: Icon(Icons.alternate_email_rounded, size: 20)),
                              ),
                              const SizedBox(height: 32),
                              _buildLabel('Master Password'),
                              TextField(
                                controller: passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, size: 18),
                                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),
                              BlocConsumer<AuthCubit, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthAuthenticated) {
                                    if (state.user.role == 'admin') {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()), (route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unauthorized: Account does not have admin privileges.')));
                                      context.read<AuthCubit>().logout();
                                    }
                                  } else if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
                                  }
                                },
                                builder: (context, state) {
                                  return DynetixButton(
                                    text: 'AUTHENTICATE',
                                    isLoading: state is AuthLoading,
                                    icon: Icons.vpn_key_rounded,
                                    onPressed: () {
                                      final email = emailController.text.trim();
                                      final password = passwordController.text.trim();
                                      if (email.isNotEmpty && password.isNotEmpty) {
                                        context.read<AuthCubit>().login(email, password);
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.textDisabled)),
    );
  }
}
