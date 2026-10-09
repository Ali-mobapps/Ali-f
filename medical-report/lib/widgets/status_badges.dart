import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  factory StatusBadge.normal({String label = 'Normal'}) {
    return StatusBadge(
      label: label,
      icon: Icons.check_circle,
      backgroundColor: AppColors.tertiaryFixed,
      textColor: AppColors.onTertiaryFixed,
    );
  }

  factory StatusBadge.clear({String label = 'Clear'}) {
    return StatusBadge(
      label: label,
      icon: Icons.verified,
      backgroundColor: AppColors.secondaryFixed,
      textColor: AppColors.onSecondaryFixed,
    );
  }

  factory StatusBadge.pending({String label = 'Pending'}) {
    return StatusBadge(
      label: label,
      icon: Icons.sync,
      backgroundColor: AppColors.surfaceContainerHighest,
      textColor: AppColors.onSurfaceVariant,
    );
  }

  factory StatusBadge.hipaa({String label = 'HIPAA Ready'}) {
    return StatusBadge(
      label: label,
      icon: Icons.shield,
      backgroundColor: AppColors.surfaceContainer,
      textColor: AppColors.tertiary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
