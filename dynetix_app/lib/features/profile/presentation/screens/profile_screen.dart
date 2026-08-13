import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../settings/presentation/screens/about_screen.dart';
import '../../../settings/presentation/screens/update_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile(userEmail);

    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: VIPTheme.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: VIPTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String name = 'User';
          String email = userEmail;

          if (state is ProfileLoaded) {
            name = state.profile.name;
            email = state.profile.email;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=customer'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: VIPTheme.primaryGold),
                      ),
                      Text(
                        email,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildProfileItem(Icons.edit_outlined, 'Edit Profile', () {}),
                _buildProfileItem(Icons.notifications_none_rounded, 'Notifications', () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(userEmail: userEmail)));
                }),
                _buildProfileItem(Icons.dark_mode_outlined, 'Theme Mode', () {}, 
                  trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) => Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                      activeColor: VIPTheme.primaryGold,
                    ),
                  )
                ),
                _buildProfileItem(Icons.settings_outlined, 'Settings', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(userEmail: userEmail)));
                }),
                _buildProfileItem(Icons.info_outline_rounded, 'About Dynetix', () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                }),
                _buildProfileItem(Icons.system_update_rounded, 'App Update', () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const AppUpdateScreen()));
                }),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VIPTheme.cardBackground,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: VIPTheme.primaryGold, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
