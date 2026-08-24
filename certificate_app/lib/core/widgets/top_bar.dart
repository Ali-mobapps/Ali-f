import 'package:flutter/material.dart';
import '../theme.dart';

class CertifyProTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CertifyProTopBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: CertifyProTheme.surface,
        border: Border(bottom: BorderSide(color: CertifyProTheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          ...?actions,
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: CertifyProTheme.onSurfaceVariant),
            onPressed: () {},
            hoverColor: CertifyProTheme.surfaceContainerHigh,
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CertifyProTheme.surfaceContainer,
              shape: BoxShape.circle,
              border: Border.all(color: CertifyProTheme.outlineVariant),
            ),
            child: const Icon(Icons.person_outline, color: CertifyProTheme.primary),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
