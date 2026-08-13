import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../bloc/auth_cubit.dart';
import '../../../customer/presentation/screens/customer_dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: VIPTheme.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: VIPTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDashboardScreen(
                  customerEmail: state.user.email,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Join Dynetix',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: VIPTheme.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create an account to start your professional journey.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  DynetixTextField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: nameController,
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  DynetixTextField(
                    label: 'Email Address',
                    hint: 'customer@dynetix.com',
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  DynetixTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  const SizedBox(height: 40),
                  DynetixButton(
                    text: 'CREATE ACCOUNT',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                        context.read<AuthCubit>().signUp(email, password, name);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold, color: VIPTheme.primaryGold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
