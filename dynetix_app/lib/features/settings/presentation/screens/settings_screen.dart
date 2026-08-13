import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import 'about_screen.dart';
import 'update_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String userEmail;
  const SettingsScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildSettingsTile(context, Icons.dark_mode_outlined, 'Theme Mode', 
              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) => Switch(
                  value: mode == ThemeMode.dark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                ),
              ),
            ),
            _buildSettingsTile(context, Icons.notifications_none_rounded, 'Notifications', 
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(userEmail: userEmail)))),
            _buildSettingsTile(context, Icons.info_outline_rounded, 'About Dynetix', 
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
            _buildSettingsTile(context, Icons.system_update_rounded, 'App Update', 
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppUpdateScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
