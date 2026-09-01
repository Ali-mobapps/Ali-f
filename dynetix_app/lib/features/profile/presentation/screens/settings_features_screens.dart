import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../../core/widgets/dynetix_widgets.dart';

class ThemePreferencesScreen extends StatelessWidget {
  const ThemePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('THEME PREFERENCES', style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visual Identity', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Choose your preferred visual mode for the application.', style: TextStyle(color: AppColors.textDisabled, fontSize: 13)),
            const SizedBox(height: 32),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return Column(
                  children: [
                    _buildThemeTile(
                      context,
                      'Dark Mode (Obsidian)',
                      'Deep blacks for better focus and battery life.',
                      Icons.dark_mode_rounded,
                      mode == ThemeMode.dark,
                      () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                    const SizedBox(height: 16),
                    _buildThemeTile(
                      context,
                      'Light Mode (Champagne)',
                      'Elegant and bright for day-time usage.',
                      Icons.light_mode_rounded,
                      mode == ThemeMode.light,
                      () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, String title, String subtitle, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: 16,
        borderColor: isSelected ? AppColors.primary : AppColors.glassBorder,
        backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textDisabled),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isSelected ? AppColors.textPrimary : AppColors.textDisabled, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushEnabled = true;
  bool chatEnabled = true;
  bool paymentEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NOTIFICATIONS', style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Alert Preferences', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Manage how you receive updates and messages.', style: TextStyle(color: AppColors.textDisabled, fontSize: 13)),
          const SizedBox(height: 32),
          _buildSwitchTile('Push Notifications', 'General app alerts and updates', pushEnabled, (v) => setState(() => pushEnabled = v)),
          const SizedBox(height: 16),
          _buildSwitchTile('Chat Messages', 'Receive alerts for new inquiries', chatEnabled, (v) => setState(() => chatEnabled = v)),
          const SizedBox(height: 16),
          _buildSwitchTile('Payment Alerts', 'Notifications for successful transactions', paymentEnabled, (v) => setState(() => paymentEnabled = v)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return GlassPanel(
      padding: 8,
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
      ),
    );
  }
}

class AboutDynetixScreen extends StatelessWidget {
  const AboutDynetixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ABOUT DYNETIX', style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const DynetixLogo(size: 100),
            const SizedBox(height: 24),
            const Text('DYNETIX', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 8, color: AppColors.textPrimary)),
            const Text('v1.0.0 Stable Build', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
            const SizedBox(height: 48),
            const GlassPanel(
              padding: 24,
              child: Text(
                'Dynetix is an elite professional solutions platform designed to bridge the gap between premium services and digital excellence. Our mission is to empower professionals and businesses with cutting-edge tools and services.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textPrimary, height: 1.6, fontSize: 14),
              ),
            ),
            const SizedBox(height: 48),
            const Text('DEVELOPED BY', style: TextStyle(color: AppColors.textDisabled, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Dynetix Engineering Team', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 64),
            TextButton(
              onPressed: () {},
              child: const Text('Terms of Service & Privacy Policy', style: TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SYSTEM SETTINGS',
            style: TextStyle(
                letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('General Configuration',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildSettingTile(context, 'Language', 'English (United States)',
              Icons.language_rounded, onTap: () {
            _showSelectionDialog(context, 'Select Language',
                ['English', 'Urdu', 'Arabic', 'Spanish']);
          }),
          const SizedBox(height: 16),
          _buildSettingTile(
              context, 'Region', 'Pakistan', Icons.location_on_rounded,
              onTap: () {
            _showSelectionDialog(context, 'Select Region',
                ['Pakistan', 'USA', 'UK', 'UAE', 'Canada']);
          }),
          const SizedBox(height: 16),
          _buildSettingTile(context, 'Storage Usage',
              'Clear cache and local data', Icons.storage_rounded, onTap: () {
            _showClearCacheDialog(context);
          }),
          const SizedBox(height: 16),
          _buildSettingTile(
              context, 'App Version', '1.0.0 (Build 240815)', Icons.info_outline_rounded,
              onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Checking for updates... Build is up to date.')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, String title, String subtitle, IconData icon,
      {VoidCallback? onTap}) {
    return GlassPanel(
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
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textDisabled, fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textDisabled),
        ),
      ),
    );
  }

  void _showSelectionDialog(
      BuildContext context, String title, List<String> options) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((opt) => ListTile(
                    title: Text(opt, style: const TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$opt selected')));
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear Storage', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Do you want to clear app cache and local data?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')));
            },
            child: const Text('Clear Now'),
          ),
        ],
      ),
    );
  }
}
