import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF06B6D4),
          brightness: Brightness.dark,
        ),
      ),
      home: const SmartHomeShell(),
    );
  }
}

class SmartHomeShell extends StatefulWidget {
  const SmartHomeShell({super.key});

  @override
  State<SmartHomeShell> createState() => _SmartHomeShellState();
}

class _SmartHomeShellState extends State<SmartHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RoomsDevicesScreen(),
    AutomationScreen(),
    HomeProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF06B6D4).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home, color: Color(0xFF06B6D4)),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.bolt, color: Color(0xFF06B6D4)),
            label: 'Automation',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.settings, color: Color(0xFF06B6D4)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: ROOMS & DEVICES ====================
class RoomsDevicesScreen extends StatelessWidget {
  const RoomsDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.hub, color: Color(0xFF06B6D4), size: 28),
                    SizedBox(width: 8),
                    Text('Nexus Home', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFF06B6D4)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E7490), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('MASTER STATUS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('All Systems Active', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('12 Devices Connected • Eco Mode On', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.power, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Smart Rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: const [
                DeviceTile(title: 'Living Room', subtitle: '4 Active Devices', icon: Icons.weekend),
                DeviceTile(title: 'Master Bedroom', subtitle: '2 Active Devices', icon: Icons.bed),
                DeviceTile(title: 'Kitchen', subtitle: '3 Active Devices', icon: Icons.kitchen),
                DeviceTile(title: 'Backyard', subtitle: '3 Active Devices', icon: Icons.deck),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const DeviceTile({super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF06B6D4), size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: AUTOMATION ====================
class AutomationScreen extends StatelessWidget {
  const AutomationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Automation Routines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 16),
            RoutineTile(title: 'Good Morning Routine', time: '06:30 AM Daily', active: true),
            RoutineTile(title: 'Away Mode Security', time: 'Triggered on Geofence', active: true),
            RoutineTile(title: 'Night Sleep Dimmer', time: '11:00 PM Daily', active: false),
          ],
        ),
      ),
    );
  }
}

class RoutineTile extends StatelessWidget {
  final String title;
  final String time;
  final bool active;

  const RoutineTile({super.key, required this.title, required this.time, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Switch(
            value: active,
            activeColor: const Color(0xFF06B6D4),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: HOME PROFILE / SETTINGS ====================
class HomeProfileScreen extends StatelessWidget {
  const HomeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF06B6D4),
                    child: Icon(Icons.home, size: 40, color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text('Villa Nexus Smart Home', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Hub Version 4.2.1 • Online', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const SettingsTile(icon: Icons.wifi, title: 'Network & Hub Connection'),
            const SettingsTile(icon: Icons.security, title: 'Security & Access Logs'),
            const SettingsTile(icon: Icons.people, title: 'Family Members Access'),
            const SettingsTile(icon: Icons.info, title: 'About System'),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingsTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF06B6D4)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}