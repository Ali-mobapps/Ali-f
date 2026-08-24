import 'package:flutter/material.dart';

void main() {
  runApp(const CyberCommandApp());
}

class CyberCommandApp extends StatelessWidget {
  const CyberCommandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Command Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF04060B), // Deep Space Matrix
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FF66), // Matrix Neon Green
          surface: const Color(0xFF0D1322),
        ),
      ),
      home: const MainDashboardShell(),
    );
  }
}

// ==================== MAIN SHELL WITH BOTTOM NAVIGATION ====================
class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ServerControlTab(),
    AnalyticsTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1322),
          border: Border(top: BorderSide(color: const Color(0xFF00FF66).withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF00FF66),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.terminal), label: 'Control'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Telemetry'),
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Security'),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 1: INTERACTIVE SERVER CONTROLS ====================
class ServerControlTab extends StatefulWidget {
  const ServerControlTab({super.key});

  @override
  State<ServerControlTab> createState() => _ServerControlTabState();
}

class _ServerControlTabState extends State<ServerControlTab> {
  bool _serverActive = true;
  bool _aiCore = true;
  double _powerLevel = 75.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('quantum command nexus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00FF66))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1322),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00FF66).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NODE STATUS', style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      Text(
                        _serverActive ? 'OPERATIONAL [SECURE]' : 'OFFLINE [STANDBY]',
                        style: TextStyle(
                          color: _serverActive ? const Color(0xFF00FF66) : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _serverActive,
                    activeThumbColor: const Color(0xFF00FF66),
                    onChanged: (val) => setState(() => _serverActive = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('interactive subsystems', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Toggle Card 1
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1322),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Color(0xFF00FF66)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Neural AI Core', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Auto-optimizing threat matrix', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _aiCore,
                    activeThumbColor: const Color(0xFF00FF66),
                    onChanged: (val) => setState(() => _aiCore = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Power Slider Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1322),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reactor Output Regulation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${_powerLevel.toInt()}%', style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _powerLevel,
                    min: 0,
                    max: 100,
                    activeColor: const Color(0xFF00FF66),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _powerLevel = val),
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

// ==================== TAB 2: TELEMETRY & ANALYTICS ====================
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('telemetry logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00FF66))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TelemetryCard(title: 'CPU Core Allocation', value: '12.4 GHz [94%]'),
          SizedBox(height: 12),
          TelemetryCard(title: 'Quantum Entanglement Rate', value: '4.8 TB/s'),
          SizedBox(height: 12),
          TelemetryCard(title: 'Packet Loss Ratio', value: '0.0001% [Nominal]'),
          SizedBox(height: 12),
          TelemetryCard(title: 'Sub-Zero Cooling Temp', value: '-196°C [Stable]'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: SECURITY PROTOCOLS ====================
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('security matrix', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00FF66))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1322),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Firewall Integrity', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 6),
                  Text('Level 5 Quantum Shield Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.black,
                    color: Color(0xFF00FF66),
                    minHeight: 6,
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

class TelemetryCard extends StatelessWidget {
  final String title, value;

  const TelemetryCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1322),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}