import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../domain/entities/service_entity.dart';
import '../../../inquiries/presentation/screens/inquiry_chat_screen.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      body: Stack(
        children: [
          // Header Image with Gradient
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            VIPTheme.primaryGold.withValues(alpha: 0.4),
                            VIPTheme.darkBackground,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          service.type == 'course' ? Icons.school_rounded : Icons.miscellaneous_services_rounded,
                          size: 100,
                          color: VIPTheme.primaryGold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: VIPTheme.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        service.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'What You\'ll Learn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLearningPoint('Expert-led training modules'),
                      _buildLearningPoint('Hands-on practical projects'),
                      _buildLearningPoint('Real-world case studies'),
                      _buildLearningPoint('Direct support and mentorship'),
                      _buildLearningPoint('Certificate of completion'),
                      const SizedBox(height: 32),
                      // Inquiry Note / Ask Admin Section
                      const Text(
                        'Service Inquiry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Have a custom requirement or question? Drop a note below.',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          final authState = context.read<AuthCubit>().state;
                          if (authState is AuthAuthenticated) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InquiryChatScreen(
                                  itemId: service.id,
                                  itemTitle: service.title,
                                  userRole: authState.user.role,
                                  userId: authState.user.id,
                                ),
                              ),
                            );
                          } else {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please login to inquire.')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: VIPTheme.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: VIPTheme.primaryGold.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Write a note to Admin...',
                                  style: TextStyle(color: Colors.white38, fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: VIPTheme.primaryGold,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 120), // Bottom padding for button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Bar with Enroll Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, VIPTheme.darkBackground.withValues(alpha: 0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: DynetixButton(
                text: 'Enroll Now',
                onPressed: () {
                  // Enrollment logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully enrolled in ${service.title}!')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: VIPTheme.primaryGold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
