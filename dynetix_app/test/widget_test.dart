// File path: lib/features/dashboard/presentation/pages/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:dynetix_app/core/storage/database_service.dart';
import 'package:dynetix_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:dynetix_app/features/tasks/presentation/pages/tasks_page.dart';
import 'package:dynetix_app/features/payments/presentation/pages/activity_page.dart';
import 'package:dynetix_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:dynetix_app/features/dashboard/presentation/pages/profile_page.dart';

class MainWrapper extends StatefulWidget {
  final String? userEmail;

  const MainWrapper({super.key, this.userEmail});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get user email and admin status safely from database or widget session
    String email = widget.userEmail ??
        AppDatabase.currentUser?['email'] ??
        'admin@dynetix.com';
    bool isAdmin = AppDatabase.currentUser?['isAdmin'] ?? false;

    final List<Widget> pages = [
      DashboardPage(userEmail: email),
      const TasksPage(),
      const ActivityPage(),
      const NotificationsPage(),
      ProfilePage(userEmail: email, isAdmin: isAdmin),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1D1E33),
        selectedItemColor: const Color(0xFF0052CC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
