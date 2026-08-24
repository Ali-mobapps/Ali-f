import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home IoT UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070B12), // Deep Cyber Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF06B6D4), // Cyber Cyan Accent
          surface: const Color(0xFF111827),
        ),
      ),
      home: const HomeDashboardScreen(),
    );
  }
}

// ==================== SCREEN 1: ROOMS & DEVICES DASHBOARD ====================
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('status: all systems secure', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('penthouse iot hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF111827),
              child: Icon(Icons.settings_input_antenna, color: Color(0xFF06B6D4)),
            ),
            onPressed: () {
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
            // Climate Summary Card
            Container(
              width: double.infinity,
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('indoor climate', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('22.5°C • 45% Humidity', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                    child: const Text('hvac control', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('active rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Horizontal Room Selector Grid / Cards
            Row(
              children: const [
                Expanded(child: RoomCard(roomName: 'Living Room', activeDevices: '5 Active', icon: Icons.weekend)),
                SizedBox(width: 12),
                Expanded(child: RoomCard(roomName: 'Master Suite', activeDevices: '3 Active', icon: Icons.bed)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: RoomCard(roomName: 'Home Theater', activeDevices: '4 Active', icon: Icons.movie)),
                SizedBox(width: 12),
                Expanded(child: RoomCard(roomName: 'Smart Kitchen', activeDevices: '2 Active', icon: Icons.kitchen)),
              ],
            ),
            const SizedBox(height: 24),

            const Text('quick toggles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            const DeviceToggleTile(name: 'Ambient LED Strips', location: 'Living Room', status: 'ON'),
            const SizedBox(height: 10),
            const DeviceToggleTile(name: 'Security Perimeter Cams', location: 'Exterior', status: 'ARMED'),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: ROOM HVAC & DEVICE CONTROL ====================
class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hvac & lighting matrix', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF06B6D4)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Master Thermostat', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Cooling Mode • Target 21°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fan Speed: Auto', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
                      Text('Filter Health: 92%', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Zone Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const ParamRow(label: 'Smart Glass Opacity', value: '15% Tinted'),
            const SizedBox(height: 8),
            const ParamRow(label: 'Air Ionizer Status', value: 'Operational'),
            const SizedBox(height: 8),
            const ParamRow(label: 'Floor Heating', value: 'Disabled'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('apply routine presets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class RoomCard extends StatelessWidget {
  final String roomName, activeDevices;
  final IconData icon;

  const RoomCard({super.key, required this.roomName, required this.activeDevices, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF06B6D4), size: 28),
          const SizedBox(height: 16),
          Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text(activeDevices, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class DeviceToggleTile extends StatelessWidget {
  final String name, location, status;

  const DeviceToggleTile({super.key, required this.name, required this.location, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF070B12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ParamRow extends StatelessWidget {
  final String label, value;

  const ParamRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}