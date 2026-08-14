import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../settings/presentation/screens/about_screen.dart';
import '../../../settings/presentation/screens/update_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile(userEmail);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String name = 'Director';
          String role = 'Elite Member';

          if (state is ProfileLoaded) {
            name = state.profile.name;
            role = state.profile.role;
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                title: const Text('PROFILE', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 16)),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Avatar
                      _buildProfileHeader(context),
                      const SizedBox(height: 24),
                      Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.softIvory)),
                      const SizedBox(height: 4),
                      Text(role.toUpperCase(), style: const TextStyle(color: AppColors.primary, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w600)),
                      
                      const SizedBox(height: 48),
                      
                      // Settings Sections
                      _buildSectionTitle('System Configuration'),
                      const SizedBox(height: 16),
                      _buildOption(context, Icons.settings_outlined, 'Account Preferences', 'Manage your core profile security'),
                      _buildOption(context, Icons.notifications_none_rounded, 'Alert Configurations', 'Routing and priority settings', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(userEmail: userEmail)))),
                      _buildOption(context, Icons.contrast_rounded, 'Interface Mode', 'Toggle high contrast VIP mode', 
                        trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, mode) => Switch(
                            value: mode == ThemeMode.dark,
                            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                            activeColor: AppColors.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      _buildSectionTitle('Information Hub'),
                      const SizedBox(height: 16),
                      _buildOption(context, Icons.info_outline_rounded, 'System Details', 'Version: VIP-9.4.2 Platinum', 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
                      _buildOption(context, Icons.system_update_rounded, 'Connectivity Check', 'Verify latest system updates',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppUpdateScreen()))),
                      
                      const SizedBox(height: 48),
                      
                      // Logout
                      DynetixButton(
                        text: 'TERMINATE SESSION',
                        color: Colors.redAccent.withOpacity(0.05),
                        textColor: Colors.redAccent,
                        isOutline: true,
                        onPressed: () => _showLogoutDialog(context),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
          ),
        ),
        const CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.charcoalDepth,
          backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.photo_camera_rounded, size: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.textDisabled, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: 4,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(title, style: const TextStyle(color: AppColors.softIvory, fontSize: 15, fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
          trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textDisabled),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Confirm Termination'),
        content: const Text('Are you sure you want to end this elite session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
            child: const Text('TERMINATE'),
          ),
        ],
      ),
    );
  }
}
