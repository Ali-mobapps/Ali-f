import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser ?? {'name': 'Dynetix User'};
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 10),
          Text(user['name'] ?? 'User', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            value: AppDatabase.isDarkMode,
            onChanged: (val) {
              AppDatabase.isDarkMode = val;
              DynetixApp.of(context)?.refreshTheme();
            },
          ),
          const Spacer(),
          ElevatedButton(onPressed: () { AppDatabase.logout(); Navigator.of(context).popUntil((route) => route.isFirst); }, child: const Text('Logout')),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
