import 'package:flutter/material.dart';
import 'package:dynetix_app/presentation/shared/service_page.dart';
import 'package:dynetix_app/presentation/shared/academy_page.dart';
import 'package:dynetix_app/presentation/shared/payment_page.dart';
import 'package:dynetix_app/presentation/shared/profile_page.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ServicePage(isAdmin: false),
    const AcademyPage(isAdmin: false),
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
        selectedItemColor: const Color(0xFF0052CC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
