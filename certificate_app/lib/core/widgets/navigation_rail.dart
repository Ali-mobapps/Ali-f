import 'package:flutter/material.dart';
import '../theme.dart';

class CertifyProNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CertifyProNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: CertifyProTheme.outline)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: CertifyProTheme.primary, size: 30),
                const SizedBox(width: 12),
                Text(
                  'CertifyPro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard', isSelected: selectedIndex == 0, onTap: () => onDestinationSelected(0)),
                _NavItem(icon: Icons.history_outlined, activeIcon: Icons.history, label: 'Issuance Logs', isSelected: selectedIndex == 1, onTap: () => onDestinationSelected(1)),
                _NavItem(icon: Icons.add_circle_outline, activeIcon: Icons.add_circle, label: 'New Certificate', isSelected: selectedIndex == 2, onTap: () => onDestinationSelected(2)),
                _NavItem(icon: Icons.palette_outlined, activeIcon: Icons.palette, label: 'Institution Branding', isSelected: selectedIndex == 3, onTap: () => onDestinationSelected(3)),
                _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'System Settings', isSelected: selectedIndex == 4, onTap: () => onDestinationSelected(4)),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _NavItem(
              icon: Icons.logout,
              label: 'Sign Out',
              isSelected: false,
              onTap: () => onDestinationSelected(5),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? CertifyProTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? (activeIcon ?? icon) : icon,
                color: isSelected ? Colors.white : CertifyProTheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : CertifyProTheme.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
