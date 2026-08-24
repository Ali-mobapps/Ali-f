import 'package:flutter/material.dart';

void main() {
  runApp(const OrbitalCockpitApp());
}

class OrbitalCockpitApp extends StatelessWidget {
  const OrbitalCockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbital Flight HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020408), // Deep Space Black
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00E5FF), // Cyber Cyan / HUD Blue
          surface: const Color(0xFF0A1118),
        ),
      ),
      home: const CockpitShell(),
    );
  }
}

// ==================== COCKPIT SHELL WITH BOTTOM NAVIGATION ====================
class CockpitShell extends StatefulWidget {
  const CockpitShell({super.key});

  @override
  State<CockpitShell> createState() => _CockpitShellState();
}

class _CockpitShellState extends State<CockpitShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FlightHUDTab(),
    NavigationRadarTab(),
    SystemDiagnosticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1118),
          border: Border(top: BorderSide(color: const Color(0xFF00E5FF).withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: 'HUD'),
            BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Radar'),
            BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Telemetry'),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 1: FLIGHT HUD CONTROLS ====================
class FlightHUDTab extends StatefulWidget {
  const FlightHUDTab({super.key});

  @override
  State<FlightHUDTab> createState() => _FlightHUDTabState();
}

class _FlightHUDTabState extends State<FlightHUDTab> {
  bool _thrustersActive = true;
  bool _shieldsUp = true;
  double _warpSpeed = 4.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('orbital vector hud', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00E5FF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Status Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1118),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FLIGHT STATUS', style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.5)),
                      SizedBox(height: 4),
                      Text(
                        'STABLE ORBIT [LOCK]',
                        style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _thrustersActive,
                    activeThumbColor: const Color(0xFF00E5FF),
                    onChanged: (val) => setState(() => _thrustersActive = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('cockpit controls', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Toggle Card 1
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1118),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Color(0xFF00E5FF)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Deflector Shields', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Energy absorption at 100%', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _shieldsUp,
                    activeThumbColor: const Color(0xFF00E5FF),
                    onChanged: (val) => setState(() => _shieldsUp = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Warp Speed Slider
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1118),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Warp Velocity Index', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${_warpSpeed.toStringAsFixed(1)}x', style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _warpSpeed,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: const Color(0xFF00E5FF),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _warpSpeed = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 2: NAVIGATION RADAR ====================
class NavigationRadarTab extends StatelessWidget {
  const NavigationRadarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('long-range scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00E5FF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0A1118),
                border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.navigation, size: 50, color: Color(0xFF00E5FF)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Sector 9: Clear Trajectory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('No hostile signatures within 50,000 km', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 3: SYSTEM DIAGNOSTICS ====================
class SystemDiagnosticsTab extends StatelessWidget {
  const SystemDiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('vessel telemetry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00E5FF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TelemetryRow(label: 'Ion Engine Core Temp', value: '840°C [Optimal]'),
          SizedBox(height: 12),
          TelemetryRow(label: 'Antimatter Fuel Reserve', value: '78.4%'),
          SizedBox(height: 12),
          TelemetryRow(label: 'Life Support Pressure', value: '1.02 Atm'),
          SizedBox(height: 12),
          TelemetryRow(label: 'Quantum Comm Relay', value: 'Connected [99.9%]'),
        ],
      ),
    );
  }
}

class TelemetryRow extends StatelessWidget {
  final String label, value;

  const TelemetryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1118),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}