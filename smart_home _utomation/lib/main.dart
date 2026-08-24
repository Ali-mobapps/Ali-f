import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19), // Deep Futuristic Navy
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00F2FE), // Electric Cyan Accent
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const SmartHomeHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: ROOMS & DEVICES DASHBOARD ====================
class SmartHomeHomeScreen extends StatelessWidget {
  const SmartHomeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('welcome home', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('penthouse iot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.power_settings_new, color: Color(0xFF00F2FE)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RoomDetailScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0072FF), Color(0xFF00F2FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('climate control active', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Living Room • 22°C', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RoomDetailScreen()),
                      );
                    },
                    child: const Text('manage settings', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('connected devices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RoomDetailScreen()),
                    );
                  },
                  child: const Text('view all ->', style: TextStyle(color: Color(0xFF00F2FE))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Device Grid / Tiles
            const DeviceTile(name: 'Smart Living Lights', location: 'Living Room', icon: Icons.lightbulb, isActive: true),
            const SizedBox(height: 10),
            const DeviceTile(name: 'AC Inverter Unit', location: 'Master Bedroom', icon: Icons.ac_unit, isActive: true),
            const SizedBox(height: 10),
            const DeviceTile(name: 'CCTV Security Camera', location: 'Main Entrance', icon: Icons.videocam, isActive: false),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: ROOM DETAILS & CONTROLS ====================
class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('room climate settings', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00F2FE))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00F2FE)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Temperature Regulator', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 10),
                  Text('22.5°C Optimal Level ❄️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.black,
                    color: Color(0xFF00F2FE),
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Automation Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const ControlRow(title: 'Auto Night Mode', status: 'Enabled', icon: Icons.nightlight_round),
            const SizedBox(height: 8),
            const ControlRow(title: 'Motion Sensor Lights', status: 'Active', icon: Icons.sensors),
            const SizedBox(height: 8),
            const ControlRow(title: 'Smart Air Purifier', status: 'Standby', icon: Icons.air),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F2FE),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('back to dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class DeviceTile extends StatelessWidget {
  final String name, location;
  final IconData icon;
  final bool isActive;

  const DeviceTile({super.key, required this.name, required this.location, required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00F2FE).withValues(alpha: 0.15) : Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isActive ? const Color(0xFF00F2FE) : Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: isActive,
            activeThumbColor: const Color(0xFF00F2FE),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}

class ControlRow extends StatelessWidget {
  final String title, status;
  final IconData icon;

  const ControlRow({super.key, required this.title, required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00F2FE)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Text(status, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}