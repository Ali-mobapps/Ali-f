import 'package:flutter/material.dart';

void main() {
  runApp(const SmartFarmApp());
}

class SmartFarmApp extends StatelessWidget {
  const SmartFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF15803D)),
      ),
      home: const FarmHomeShell(),
    );
  }
}

class FarmHomeShell extends StatefulWidget {
  const FarmHomeShell({super.key});

  @override
  State<FarmHomeShell> createState() => _FarmHomeShellState();
}

class _FarmHomeShellState extends State<FarmHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FarmDashboardTab(),
    const IrrigationScheduleTab(),
    const FarmSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF15803D).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco, color: Color(0xFF15803D)),
            label: 'Sensors',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop, color: Color(0xFF15803D)),
            label: 'Irrigation',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFF15803D)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class FarmDashboardTab extends StatelessWidget {
  const FarmDashboardTab({super.key});

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
                    Icon(Icons.agriculture, color: Color(0xFF15803D), size: 28),
                    SizedBox(width: 10),
                    Text('GreenFields IoT', style: TextStyle(color: Color(0xFF14361C), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.wb_sunny_outlined, color: Color(0xFF15803D)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Soil Health Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF166534), Color(0xFF15803D)],
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
                      Text('SECTOR A • WHEAT CROP', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Soil Moisture: 71%', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Air Temp: 27°C • Humidity: 54%', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.grass, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Field Zones Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF14361C))),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                ZoneBox(title: 'North Greenhouse', value: '74% Hydration', status: 'Optimal'),
                ZoneBox(title: 'South Orchard', value: '42% Dry Soil', status: 'Attention'),
                ZoneBox(title: 'East Corn Field', value: '82% Hydration', status: 'Optimal'),
                ZoneBox(title: 'West Veg Bed', value: 'Valve Open', status: 'Irrigating'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ZoneBox extends StatelessWidget {
  final String title;
  final String value;
  final String status;

  const ZoneBox({super.key, required this.title, required this.value, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Color(0xFF14361C), fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(status, style: TextStyle(color: status == 'Attention' ? Colors.orange : const Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class IrrigationScheduleTab extends StatelessWidget {
  const IrrigationScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Irrigation Control Panel', style: TextStyle(color: Color(0xFF14361C))));
  }
}

class FarmSettingsTab extends StatelessWidget {
  const FarmSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Farm System Settings', style: TextStyle(color: Color(0xFF14361C))));
  }
}