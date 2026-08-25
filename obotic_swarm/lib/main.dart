import 'package:flutter/material.dart';

void main() {
  runApp(const SwarmCommandApp());
}

class SwarmCommandApp extends StatelessWidget {
  const SwarmCommandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autonomous Swarm Command',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16), // Deep Industrial Navy
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFF59E0B), // Industrial Amber / Warning Gold
          surface: const Color(0xFF131B2E),
        ),
      ),
      home: const SwarmShell(),
    );
  }
}

// ==================== SWARM SHELL ====================
class SwarmShell extends StatefulWidget {
  const SwarmShell({super.key});

  @override
  State<SwarmShell> createState() => _SwarmShellState();
}

class _SwarmShellState extends State<SwarmShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SwarmControlTab(),
    TelemetryMapTab(),
    DiagnosticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFF59E0B),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.hub),
              label: 'Swarm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Telemetry',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_suggest),
              label: 'Diagnostics',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 1: SWARM CONTROL ====================
class SwarmControlTab extends StatefulWidget {
  const SwarmControlTab({super.key});

  @override
  State<SwarmControlTab> createState() => _SwarmControlTabState();
}

class _SwarmControlTabState extends State<SwarmControlTab> {
  bool _autonomousMode = true;
  bool _obstacleAvoidance = true;
  double _patrolAltitude = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sector-7 autonomous swarm grid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFFF59E0B),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ACTIVE DRONE UNITS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '24 / 24 UNITS ONLINE',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF090D16),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        'SYNCED',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'operational parameters',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.precision_manufacturing, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Autonomous AI Navigation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Neural mesh pathfinding active',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _autonomousMode,
                    activeThumbColor: const Color(0xFFF59E0B),
                    onChanged: (val) => setState(() => _autonomousMode = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.radar, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'LiDAR Obstacle Avoidance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Real-time spatial mapping',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _obstacleAvoidance,
                    activeThumbColor: const Color(0xFFF59E0B),
                    onChanged: (val) => setState(() => _obstacleAvoidance = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Target Patrol Altitude',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${_patrolAltitude.toInt()} Meters',
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _patrolAltitude,
                    min: 20.0,
                    max: 500.0,
                    divisions: 24,
                    activeColor: const Color(0xFFF59E0B),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _patrolAltitude = val),
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

// ==================== TAB 2: TELEMETRY MAP ====================
class TelemetryMapTab extends StatelessWidget {
  const TelemetryMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'live spatial telemetry logs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFFF59E0B),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TelemetryRowCard(label: 'Swarm Formation Density', value: 'Optimal [1.4m spacing]'),
          SizedBox(height: 10),
          TelemetryRowCard(label: 'Average Battery Reserve', value: '88.4% [Stable]'),
          SizedBox(height: 10),
          TelemetryRowCard(label: 'Wind Vector Resistance', value: '14.2 km/h [North-East]'),
          SizedBox(height: 10),
          TelemetryRowCard(label: 'Mesh Signal Latency', value: '2.4 ms'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: DIAGNOSTICS ====================
class DiagnosticsTab extends StatelessWidget {
  const DiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'system hardware diagnostics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFFF59E0B),
          ),
        ),
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
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rotor Actuator Integrity Check',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '100% Operational Efficiency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.black,
                    color: Color(0xFFF59E0B),
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

class TelemetryRowCard extends StatelessWidget {
  final String label, value;

  const TelemetryRowCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}