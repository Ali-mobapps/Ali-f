import 'package:flutter/material.dart';

void main() {
  runApp(const EVChargeApp());
}

class EVChargeApp extends StatelessWidget {
  const EVChargeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
      ),
      home: const EVHomeShell(),
    );
  }
}

class EVHomeShell extends StatefulWidget {
  const EVHomeShell({super.key});

  @override
  State<EVHomeShell> createState() => _EVHomeShellState();
}

class _EVHomeShellState extends State<EVHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EVDashboardTab(),
    const EVStationsTab(),
    const EVProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF111827),
        indicatorColor: const Color(0xFF10B981).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.bolt, color: Color(0xFF10B981)),
            label: 'Battery',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.map, color: Color(0xFF10B981)),
            label: 'Stations',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Color(0xFF10B981)),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class EVDashboardTab extends StatelessWidget {
  const EVDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.electric_car, color: Color(0xFF10B981), size: 28),
                    SizedBox(width: 10),
                    Text('VoltPulse EV', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF10B981)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Battery Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981)],
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
                      Text('TESLA MODEL 3 • LONG RANGE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('84% Charged', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Estimated Range: 410 km', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.battery_charging_full, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Live Vehicle Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                StatBox(title: 'Battery Temp', value: '31°C', subtitle: 'Optimal'),
                StatBox(title: 'Tire Pressure', value: '36 PSI', subtitle: 'All Good'),
                StatBox(title: 'Efficiency', value: '142 Wh/km', subtitle: 'High'),
                StatBox(title: 'Odometer', value: '28,400 km', subtitle: 'Total'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const StatBox({super.key, required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class EVStationsTab extends StatelessWidget {
  const EVStationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Nearby Charging Stations Map', style: TextStyle(color: Colors.white)));
  }
}

class EVProfileTab extends StatelessWidget {
  const EVProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('EV Account Settings', style: TextStyle(color: Colors.white)));
  }
}