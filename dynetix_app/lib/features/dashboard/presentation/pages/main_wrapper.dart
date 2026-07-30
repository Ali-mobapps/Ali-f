// File path: lib/features/dashboard/presentation/pages/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:dynetix_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:dynetix_app/features/tasks/presentation/pages/tasks_page.dart';
import 'package:dynetix_app/features/payments/presentation/pages/payments_page.dart';
import 'package:dynetix_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dynetix_app/features/profile/presentation/pages/profile_page.dart';
import 'package:dynetix_app/features/settings/presentation/pages/settings_page.dart';
import 'package:dynetix_app/features/auth/presentation/pages/login_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TasksPage(),
    const PaymentsPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0A0E21),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1D1E33)),
              accountName: Text('Ali Hassan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              accountEmail: Text('ali.hassan@dynetix.com', style: TextStyle(color: Colors.grey)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color(0xFF0052CC),
                child: Text('AH', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white70),
              title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 0); },
            ),
            ListTile(
              leading: const Icon(Icons.task, color: Colors.white70),
              title: const Text('My Tasks', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 1); },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.white70),
              title: const Text('Payments', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 2); },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white70),
              title: const Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 3); },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white70),
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 4); },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white70),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1D1E33),
        selectedItemColor: const Color(0xFF0052CC),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}