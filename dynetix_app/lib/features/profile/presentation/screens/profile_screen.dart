import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'edit_profile_screen.dart';
import 'settings_features_screens.dart';
import 'package:dynetix_app/features/support/presentation/screens/ai_assistant_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final bool showAppBar;

  const ProfileScreen(
      {super.key, required this.userEmail, this.showAppBar = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        String name = widget.userEmail.split('@').first;
        String role = 'Member';
        String? imageUrl;

        if (state is ProfileLoaded) {
          name = state.profile.name;
          role = state.profile.role;
          imageUrl = state.profile.profileImageUrl;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 2),
                      ),
                    ),
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: AppColors.charcoalDepth,
                      child: ClipOval(
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                          ? Image.network(
                              imageUrl,
                              width: 108,
                              height: 108,
                              fit: BoxFit.cover,
                              key: ValueKey(imageUrl),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 108,
                                height: 108,
                                color: AppColors.cardBackground,
                                child: const Icon(Icons.person_rounded, size: 54, color: AppColors.primary),
                              ),
                            )
                          : Container(
                              width: 108,
                              height: 108,
                              color: AppColors.cardBackground,
                              child: const Icon(Icons.person_rounded, size: 54, color: AppColors.primary),
                            ),
                      ),
                    ),
                    if (state is ProfileLoaded)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(profile: state.profile),
                                ),
                              ).then((_) {
                                context.read<ProfileCubit>().fetchProfile(widget.userEmail);
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name & Role
              Text(name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(role.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.primary,
                        letterSpacing: 1,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 48),

              // Settings Options
              _buildOption(
                context,
                Icons.person_outline_rounded,
                'Account Settings',
                'Update your personal information',
                onTap: () {
                  if (state is ProfileLoaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(profile: state.profile),
                      ),
                    );
                  }
                },
              ),
              _buildOption(
                context,
                Icons.psychology_rounded,
                'AI Assistant',
                'Get instant help from our AI',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiAssistantScreen())),
              ),
              _buildOption(
                context,
                Icons.palette_outlined,
                'Theme Preferences',
                'Switch between dark and light modes',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemePreferencesScreen())),
              ),
              _buildOption(
                context,
                Icons.notifications_none_rounded,
                'Notifications',
                'Manage app alerts and sounds',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
              ),
              _buildOption(
                context,
                Icons.security_rounded,
                'System Settings',
                'App language and storage control',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SystemSettingsScreen())),
              ),
              _buildOption(
                context,
                Icons.info_outline_rounded,
                'About Dynetix',
                'Version info and company details',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutDynetixScreen())),
              ),

              const SizedBox(height: 48),

              // Logout
              DynetixButton(
                text: 'LOGOUT',
                color: Colors.redAccent.withValues(alpha: 0.1),
                textColor: Colors.redAccent,
                isOutline: true,
                onPressed: () => _showLogoutDialog(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );

    if (!widget.showAppBar) return content;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROFILE',
            style: TextStyle(
                letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: content,
    );
  }

  Widget _buildOption(
      BuildContext context, IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassPanel(
        padding: 0,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: onTap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            subtitle: Text(subtitle,
                style: const TextStyle(
                    color: AppColors.textDisabled, fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textDisabled),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/role-selection', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
