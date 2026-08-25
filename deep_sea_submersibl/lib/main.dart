import 'package:flutter/material.dart';

void main() {
  runApp(const DeepSeaExplorerApp());
}

class DeepSeaExplorerApp extends StatelessWidget {
  const DeepSeaExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF06B6D4); // Cyan Ocean Glow
    const surfaceColor = Color(0xFF0B132B); // Deep Abyss Navy

    return MaterialApp(
      title: 'Deep-Sea Submersible Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030712), // Pitch Dark Trench
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: surfaceColor,
        ),
      ),
      home: const SubmersibleShell(),
    );
  }
}

// ==================== SUBMERSIBLE SHELL ====================
class SubmersibleShell extends StatefulWidget {
  const SubmersibleShell({super.key});

  @override
  State<SubmersibleShell> createState() => _SubmersibleShellState();
}

class _SubmersibleShellState extends State<SubmersibleShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SubmersibleControlTab(),
    SonarMappingTab(),
    LifeSupportTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0B132B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF06B6D4),
            unselectedItemColor: Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.sailing_rounded),
                label: 'Helm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.radar),
                label: 'Sonar Grid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bubble_chart),
                label: 'Biosphere',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TAB 1: SUBMERSIBLE HELM & PRESSURE ====================
class SubmersibleControlTab extends StatefulWidget {
  const SubmersibleControlTab({super.key});

  @override
  State<SubmersibleControlTab> createState() => _SubmersibleControlTabState();
}

class _SubmersibleControlTabState extends State<SubmersibleControlTab> {
  bool _ballastPump = true;
  bool _sonarActive = true;
  double _diveDepth = 3850.0; // Meters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'titan-v deep trench control // depth: 3.8km',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
            color: Color(0xFF06B6D4),
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
            // Status Banner Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E7490), Color(0xFF0B132B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXTERNAL HULL PRESSURE',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '385.2 MPa [STABLE]',
                        style: TextStyle(
                          color: Color(0xFF06B6D4),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.shield_rounded, color: Color(0xFF06B6D4), size: 36),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'hydro-mechanical overrides',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Interactive Switch Cards
            Row(
              children: [
                Expanded(
                  child: _buildToggleCard(
                    title: 'Ballast Pump',
                    subtitle: _ballastPump ? 'Auto-Balancing' : 'Manual',
                    icon: Icons.water_drop,
                    value: _ballastPump,
                    onChanged: (val) => setState(() => _ballastPump = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggleCard(
                    title: 'Active Sonar',
                    subtitle: _sonarActive ? '360° Sweep' : 'Standby',
                    icon: Icons.radar,
                    value: _sonarActive,
                    onChanged: (val) => setState(() => _sonarActive = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Descent Depth Slider Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0B132B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target Descent Depth',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${_diveDepth.toInt()} Meters',
                        style: const TextStyle(
                          color: Color(0xFF06B6D4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _diveDepth,
                    min: 100.0,
                    max: 11000.0,
                    divisions: 40,
                    activeColor: const Color(0xFF06B6D4),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _diveDepth = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value ? const Color(0xFF06B6D4) : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF06B6D4), size: 22),
              Switch(
                value: value,
                activeThumbColor: const Color(0xFF06B6D4),
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

// ==================== TAB 2: SONAR & TOPOGRAPHY MAPPING ====================
class SonarMappingTab extends StatelessWidget {
  const SonarMappingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'abyssal trench topography',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
            color: Color(0xFF06B6D4),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SonarSectorCard(sector: 'Mariana Trench Sector Alpha', status: 'Mapped [No Hazards]'),
          SizedBox(height: 12),
          SonarSectorCard(sector: 'Hydrothermal Vent Cluster B', status: 'Active Thermal Plumes [412°C]'),
          SizedBox(height: 12),
          SonarSectorCard(sector: 'Abyssal Plain Outpost', status: 'Clear Line of Sight'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: LIFE SUPPORT & BIOSPHERE ====================
class LifeSupportTab extends StatelessWidget {
  const LifeSupportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'internal biosphere & life support',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
            color: Color(0xFF06B6D4),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF0B132B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.2),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Oxygen Scrubber Efficiency',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                '99.8% Pure Oxygen [Closed Loop]',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 0.99,
                backgroundColor: Colors.black,
                color: Color(0xFF06B6D4),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SonarSectorCard extends StatelessWidget {
  final String sector, status;

  const SonarSectorCard({super.key, required this.sector, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B132B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sector,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.waves, color: Color(0xFF06B6D4), size: 20),
        ],
      ),
    );
  }
}