import 'package:flutter/material.dart';

void main() {
  runApp(const DysonSphereApp());
}

class DysonSphereApp extends StatelessWidget {
  const DysonSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    const solarGold = Color(0xFFFBBF24); // Solar Flare Gold
    const deepSpace = Color(0xFF0F141C); // Stellar Void

    return MaterialApp(
      title: 'Dyson Sphere Stellar Grid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: deepSpace,
        colorScheme: ColorScheme.dark(
          primary: solarGold,
          surface: const Color(0xFF182232),
        ),
      ),
      home: const DysonShell(),
    );
  }
}

// ==================== DYSON SHELL ====================
class DysonShell extends StatefulWidget {
  const DysonShell({super.key});

  @override
  State<DysonShell> createState() => _DysonShellState();
}

class _DysonShellState extends State<DysonShell> {
  int _tabIndex = 0;

  final List<Widget> _dysonScreens = const [
    SolarCollectorTab(),
    EnergyMatrixTab(),
    StellarDefenseTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dysonScreens[_tabIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF182232),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (idx) => setState(() => _tabIndex = idx),
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFFFBBF24),
            unselectedItemColor: Colors.grey.shade500,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.wb_sunny_rounded),
                label: 'Collectors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bolt_rounded),
                label: 'Power Grid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.security_rounded),
                label: 'Shields',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TAB 1: SOLAR COLLECTORS ====================
class SolarCollectorTab extends StatefulWidget {
  const SolarCollectorTab({super.key});

  @override
  State<SolarCollectorTab> createState() => _SolarCollectorTabState();
}

class _SolarCollectorTabState extends State<SolarCollectorTab> {
  bool _plasmaRelay = true;
  bool _photonCapture = true;
  double _harvestRate = 88.5; // Yottawatts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'dyson swarm node-01 // stellar harvester',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFFFBBF24),
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
            // Solar Flare Gradient Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF78350F), Color(0xFF182232)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STELLAR ENERGY HARVEST',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '3.42 YOTTAWATTS',
                        style: TextStyle(
                          color: Color(0xFFFBBF24),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.local_fire_department, color: Color(0xFFFBBF24), size: 36),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'collector sail configuration',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Grid Cards Style
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildSolarGridCard(
                  title: 'Plasma Relay',
                  subtitle: _plasmaRelay ? 'Active' : 'Standby',
                  icon: Icons.electric_bolt,
                  value: _plasmaRelay,
                  onChanged: (val) => setState(() => _plasmaRelay = val),
                ),
                _buildSolarGridCard(
                  title: 'Photon Capture',
                  subtitle: _photonCapture ? 'Focused' : 'Unfocused',
                  icon: Icons.flare,
                  value: _photonCapture,
                  onChanged: (val) => setState(() => _photonCapture = val),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Harvest Rate Slider
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF182232),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Collector Efficiency Index',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${_harvestRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Color(0xFFFBBF24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _harvestRate,
                    min: 10.0,
                    max: 100.0,
                    divisions: 18,
                    activeColor: const Color(0xFFFBBF24),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _harvestRate = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarGridCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF182232),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value ? const Color(0xFFFBBF24) : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFFFBBF24), size: 22),
              Switch(
                value: value,
                activeThumbColor: const Color(0xFFFBBF24),
                onChanged: onChanged,
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

// ==================== TAB 2: POWER MATRIX ====================
class EnergyMatrixTab extends StatelessWidget {
  const EnergyMatrixTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'planetary beam transmission matrix',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFFFBBF24),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          PowerRouteCard(node: 'Earth Transmission Beam 01', status: 'Active [1.2 YW]'),
          SizedBox(height: 12),
          PowerRouteCard(node: 'Mars Colony Relay Link', status: 'Active [0.8 YW]'),
          SizedBox(height: 12),
          PowerRouteCard(node: 'Deep Space Outpost Node', status: 'Standby [0.4 YW]'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: STELLAR DEFENSE ====================
class StellarDefenseTab extends StatelessWidget {
  const StellarDefenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'solar flare magnetic shielding',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFFFBBF24),
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
            color: const Color(0xFF182232),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Coronal Mass Ejection Deflector',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                '100% Shield Integrity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.black,
                color: Color(0xFFFBBF24),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PowerRouteCard extends StatelessWidget {
  final String node, status;

  const PowerRouteCard({super.key, required this.node, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF182232),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
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
                  node,
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
          const Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 20),
        ],
      ),
    );
  }
}