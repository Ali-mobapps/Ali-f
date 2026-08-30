import 'package:flutter/material.dart';

void main() {
  runApp(const AgriFarmApp());
}

class AgriFarmApp extends StatelessWidget {
  const AgriFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F8F1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF388E3C)),
      ),
      home: const FarmHomeScreen(),
    );
  }
}

class FarmHomeScreen extends StatefulWidget {
  const FarmHomeScreen({super.key});

  @override
  State<FarmHomeScreen> createState() => _FarmHomeScreenState();
}

class _FarmHomeScreenState extends State<FarmHomeScreen> with SingleTickerProviderStateMixin {
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
            Icon(Icons.eco, color: Color(0xFF388E3C), size: 24),
            SizedBox(width: 8),
            Text('GreenFields IoT Farm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3B1A))),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: IconButton(
              icon: const Icon(Icons.wb_sunny_outlined, color: Color(0xFF388E3C)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCECCF),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF388E3C),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF557C53),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Sensors & Zones'),
                Tab(text: 'Irrigation & Harvest'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SensorsZonesTab(),
          IrrigationHarvestTab(),
        ],
      ),
    );
  }
}

class SensorsZonesTab extends StatelessWidget {
  const SensorsZonesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather & Soil Health Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF388E3C).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Sector A • Wheat Crop', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 6),
                    Text('Soil Moisture: 68%', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Air Temp: 28°C • Humidity: 55%', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.grass, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Field Zones Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3B1A))),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: const [
              ZoneCard(title: 'North Greenhouse', status: 'Optimal', value: '72% Hydration', icon: Icons.house),
              ZoneCard(title: 'South Orchard', status: 'Attention', value: '45% Dry Soil', icon: Icons.local_florist),
              ZoneCard(title: 'East Corn Field', status: 'Optimal', value: '80% Hydration', icon: Icons.agriculture),
              ZoneCard(title: 'West Vegetable Bed', status: 'Irrigating', value: 'Valve Open', icon: Icons.water_drop),
            ],
          ),
        ],
      ),
    );
  }
}

class ZoneCard extends StatelessWidget {
  final String title;
  final String status;
  final String value;
  final IconData icon;

  const ZoneCard({super.key, required this.title, required this.status, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF388E3C), size: 22),
              Text(status, style: TextStyle(fontSize: 10, color: status == 'Attention' ? Colors.orange : Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF557C53))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B3B1A))),
            ],
          ),
        ],
      ),
    );
  }
}

class IrrigationHarvestTab extends StatelessWidget {
  const IrrigationHarvestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Automated Irrigation Schedules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3B1A))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ScheduleTile(zone: 'North Greenhouse Sprinklers', time: '05:00 AM Daily', status: 'Active'),
              ScheduleTile(zone: 'South Orchard Drip Line', time: '06:30 AM Daily', status: 'Paused'),
              ScheduleTile(zone: 'East Corn Field Pivots', time: '09:00 PM Cycle', status: 'Scheduled'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Harvest Estimates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3B1A))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_today, color: Color(0xFF388E3C)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Wheat Crop Season 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1B3B1A))),
                      SizedBox(height: 2),
                      Text('Estimated Yield: 4.2 Tons • Due in 18 days', style: TextStyle(fontSize: 12, color: Color(0xFF557C53))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleTile extends StatelessWidget {
  final String zone;
  final String time;
  final String status;

  const ScheduleTile({super.key, required this.zone, required this.time, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Color(0xFF388E3C)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(zone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B3B1A))),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Color(0xFF557C53), fontSize: 12)),
              ],
            ),
          ),
          Text(status, style: TextStyle(color: status == 'Active' ? const Color(0xFF388E3C) : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}