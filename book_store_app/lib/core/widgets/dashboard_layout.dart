import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int selectedIndex;

  const DashboardLayout({
    super.key,
    required this.child,
    this.title = 'BookStock Manager',
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.menu_book),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      drawer: !isDesktop
          ? Drawer(
              child: _NavigationContent(selectedIndex: selectedIndex),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEFF),
                border: Border(
                  right: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: _NavigationContent(selectedIndex: selectedIndex),
            ),
          Expanded(
            child: Container(
              color: const Color(0xFFF9F9FF),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationContent extends StatelessWidget {
  final int selectedIndex;

  const _NavigationContent({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Portal',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'Main Street Books',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'v2.4.0',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _NavTile(
                icon: Icons.list_alt,
                label: 'Inventory Management',
                isActive: selectedIndex == 0,
                onTap: () => Navigator.pushReplacementNamed(context, '/inventory'),
              ),
              _NavTile(
                icon: Icons.shopping_cart_outlined,
                label: 'POS Terminal',
                isActive: selectedIndex == 1,
                onTap: () => Navigator.pushReplacementNamed(context, '/pos'),
              ),
              _NavTile(
                icon: Icons.history,
                label: 'Sales Ledger',
                isActive: selectedIndex == 2,
                onTap: () => Navigator.pushReplacementNamed(context, '/history'),
              ),
              _NavTile(
                icon: Icons.person_search_outlined,
                label: 'Customer Credit',
                isActive: selectedIndex == 3,
                onTap: () => Navigator.pushReplacementNamed(context, '/ledger'),
              ),
              _NavTile(
                icon: Icons.trending_up,
                label: 'Business Reports',
                isActive: selectedIndex == 4,
                onTap: () => Navigator.pushReplacementNamed(context, '/insights'),
              ),
              _NavTile(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: selectedIndex == 5,
                onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
