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
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E), brightness: Brightness.dark),
      ),
      home: const EVDashboardScreen(),
    );
  }
}

class EVDashboardScreen extends StatefulWidget {
  const EVDashboardScreen({super.key});

  @override
  State<EVDashboardScreen> createState() => _EVDashboardScreenState();
}

class _EVDashboardScreenState extends State<EVDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.ev_station, color: Color(0xFF22C55E), size: 24),
            SizedBox(width: 8),
            Text('VoltPulse EV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF22C55E)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF22C55E),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Vehicle & Battery'),
                Tab(text: 'Nearby Chargers'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VehicleBatteryTab(),
          NearbyChargersTab(),
        ],
      ),
    );
  }
}

class VehicleBatteryTab extends StatelessWidget {
  const VehicleBatteryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Battery Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF166534), Color(0xFF22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Tesla Model 3 • Long Range', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 6),
                    Text('82%', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Range: 380 km • Charging Completed', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.battery_charging_full, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Live Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: const [
              StatCard(title: 'Battery Temp', value: '32°C', subtitle: 'Optimal', icon: Icons.thermostat),
              StatCard(title: 'Tire Pressure', value: '36 PSI', subtitle: 'All Normal', icon: Icons.speed),
              StatCard(title: 'Energy Used', value: '148 Wh/km', subtitle: 'Efficient', icon: Icons.flash_on),
              StatCard(title: 'Odometer', value: '24,500 km', subtitle: 'Total Drive', icon: Icons.directions_car),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const StatCard({super.key, required this.title, required this.value, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF22C55E), size: 22),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class NearbyChargersTab extends StatelessWidget {
  const NearbyChargersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Charging Stations Nearby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ChargerTile(name: 'VoltHub Supercharger', distance: '1.2 km away', speed: '150 kW • Ultra Fast', available: '4/6 Available', isFree: true),
              ChargerTile(name: 'GreenEnergy Station', distance: '3.5 km away', speed: '50 kW • Fast', available: '2/4 Available', isFree: false),
              ChargerTile(name: 'City Mall EV Hub', distance: '5.0 km away', speed: '22 kW • Standard', available: '0/2 Available', isFree: false),
            ],
          ),
        ],
      ),
    );
  }
}

class ChargerTile extends StatelessWidget {
  final String name;
  final String distance;
  final String speed;
  final String available;
  final bool isFree;

  const ChargerTile({super.key, required this.name, required this.distance, required this.speed, required this.available, required this.isFree});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt, color: Color(0xFF22C55E)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 2),
                Text('$distance • $speed', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(available, style: TextStyle(color: isFree ? const Color(0xFF22C55E) : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}