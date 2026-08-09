import 'package:flutter/material.dart';
import 'package:dynetix_app/presentation/shared/service_page.dart';
import 'package:dynetix_app/presentation/shared/academy_page.dart';
import 'package:dynetix_app/presentation/shared/payment_page.dart';
import 'package:dynetix_app/presentation/shared/profile_page.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ServicePage(isAdmin: true),
    const AcademyPage(isAdmin: true),
    const PaymentPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1D1E33),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.design_services), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
