import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int selectedIndex;
  final List<Widget>? actions;

  const DashboardLayout({
    super.key,
    required this.child,
    this.title = 'Local Shop Store',
    this.selectedIndex = 0,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: actions ?? [
          IconButton(icon: const Icon(Icons.notifications_none_rounded, size: 22), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => Get.toNamed('/profile'),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF334155),
                  child: Icon(Icons.person_rounded, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (!isMobile)
            _Sidebar(selectedIndex: selectedIndex),
          Expanded(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? _BottomNav(selectedIndex: selectedIndex)
          : null,
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  const _Sidebar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(right: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _SidebarTile(
            icon: Icons.grid_view_rounded,
            label: 'inventory'.tr,
            isActive: selectedIndex == 0,
            onTap: () => Get.offAllNamed('/inventory'),
          ),
          _SidebarTile(
            icon: Icons.point_of_sale_rounded,
            label: 'pos'.tr,
            isActive: selectedIndex == 1,
            onTap: () => Get.offAllNamed('/pos'),
          ),
          _SidebarTile(
            icon: Icons.receipt_long_rounded,
            label: 'bills'.tr,
            isActive: selectedIndex == 2,
            onTap: () => Get.offAllNamed('/history'),
          ),
          _SidebarTile(
            icon: Icons.people_alt_rounded,
            label: 'ledger'.tr,
            isActive: selectedIndex == 3,
            onTap: () => Get.offAllNamed('/ledger'),
          ),
          _SidebarTile(
            icon: Icons.public_rounded,
            label: 'Online',
            isActive: selectedIndex == 4,
            onTap: () => Get.offAllNamed('/online_customers'),
          ),
          _SidebarTile(
            icon: Icons.analytics_rounded,
            label: 'insights'.tr,
            isActive: selectedIndex == 5,
            onTap: () => Get.offAllNamed('/insights'),
          ),
          const Spacer(),
          _SidebarTile(
            icon: Icons.settings_rounded,
            label: 'settings'.tr,
            isActive: selectedIndex == 6,
            onTap: () => Get.offAllNamed('/settings'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? const Color(0xFF1E293B) : Colors.transparent,
        leading: Icon(
          icon, 
          color: isActive ? Colors.white : const Color(0xFF94A3B8), 
          size: 20
        ),
        title: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isActive ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  const _BottomNav({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          final routes = [
            '/inventory', 
            '/pos', 
            '/history', 
            '/ledger', 
            '/online_customers', 
            '/insights', 
            '/settings'
          ];
          Get.offAllNamed(routes[index]);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 8),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 8),
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view_rounded, size: 18), label: 'inventory'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.point_of_sale_rounded, size: 18), label: 'pos'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long_rounded, size: 18), label: 'bills'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.people_alt_rounded, size: 18), label: 'ledger'.tr),
          const BottomNavigationBarItem(icon: Icon(Icons.public_rounded, size: 18), label: 'Online'),
          BottomNavigationBarItem(icon: const Icon(Icons.analytics_rounded, size: 18), label: 'insights'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.settings_rounded, size: 18), label: 'settings'.tr),
        ],
      ),
    );
  }
}
