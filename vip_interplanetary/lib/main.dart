import 'package:flutter/material.dart';

void main() {
  runApp(const TerraformingApp());
}

class TerraformingApp extends StatelessWidget {
  const TerraformingApp({super.key});

  @override
  Widget build(BuildContext context) {
    const limeAccent = Color(0xFF84CC16); // Terraforming Neon Lime
    const darkMars = Color(0xFF18181B); // Carbon Dark

    return MaterialApp(
      title: 'Interplanetary Terraforming Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B),
        colorScheme: ColorScheme.dark(
          primary: limeAccent,
          surface: darkMars,
        ),
      ),
      home: const TerraformingShell(),
    );
  }
}

// ==================== TERRAFORMING SHELL ====================
class TerraformingShell extends StatefulWidget {
  const TerraformingShell({super.key});

  @override
  State<TerraformingShell> createState() => _TerraformingShellState();
}

class _TerraformingShellState extends State<TerraformingShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AtmosphereControlTab(),
    BiosphereGridTab(),
    ThermalRadiatorTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF84CC16).withValues(alpha: 0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF84CC16),
            unselectedItemColor: Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_sync_rounded),
                label: 'Atmosphere',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.eco_rounded),
                label: 'Biosphere',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.solar_power_rounded),
                label: 'Radiators',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TAB 1: ATMOSPHERE CONTROL ====================
class AtmosphereControlTab extends StatefulWidget {
  const AtmosphereControlTab({super.key});

  @override
  State<AtmosphereControlTab> createState() => _AtmosphereControlTabState();
}

class _AtmosphereControlTabState extends State<AtmosphereControlTab> {
  bool _nitrogenGen = true;
  bool _pressureDome = true;
  double _oxygenPurity = 21.5; // Percentage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sector-4 atmospheric generator // status: active',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFF84CC16),
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
            // Top Status Header Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF365314), Color(0xFF18181B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF84CC16).withValues(alpha: 0.4),
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
                          'GLOBAL BAROMETRIC PRESSURE',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '101.3 kPa [EARTH-NORM]',
                          style: TextStyle(
                            color: Color(0xFF84CC16),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.public, color: Color(0xFF84CC16), size: 36),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'atmospheric modulation units',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Grid Layout Instead of Rows
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildControlCard(
                  title: 'Nitrogen Forge',
                  subtitle: _nitrogenGen ? 'Injecting' : 'Standby',
                  icon: Icons.air,
                  value: _nitrogenGen,
                  onChanged: (val) => setState(() => _nitrogenGen = val),
                ),
                _buildControlCard(
                  title: 'Dome Shield',
                  subtitle: _pressureDome ? 'Sealed' : 'Open',
                  icon: Icons.shield,
                  value: _pressureDome,
                  onChanged: (val) => setState(() => _pressureDome = val),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Oxygen Slider Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF84CC16).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target Oxygen Enrichment',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${_oxygenPurity.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Color(0xFF84CC16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _oxygenPurity,
                    min: 10.0,
                    max: 40.0,
                    divisions: 30,
                    activeColor: const Color(0xFF84CC16),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _oxygenPurity = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value ? const Color(0xFF84CC16) : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF84CC16), size: 22),
              Switch(
                value: value,
                activeThumbColor: const Color(0xFF84CC16),
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

// ==================== TAB 2: BIOSPHERE GRID ====================
class BiosphereGridTab extends StatelessWidget {
  const BiosphereGridTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'synthetic ecosystem status',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFF84CC16),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          EcosystemCard(zone: 'Valles Marineris Greenhouse 01', metrics: 'Humidity: 68% // Flora: Thriving'),
          SizedBox(height: 12),
          EcosystemCard(zone: 'Arsia Mons Sub-Surface Nursery', metrics: 'Humidity: 74% // Flora: Stable'),
          SizedBox(height: 12),
          EcosystemCard(zone: 'Elysium Planitia Soil Matrix', metrics: 'Nutrient Index: Optimal'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: THERMAL RADIATORS ====================
class ThermalRadiatorTab extends StatelessWidget {
  const ThermalRadiatorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'thermal core & heat sinks',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.2,
            color: Color(0xFF84CC16),
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
            color: const Color(0xFF18181B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF84CC16).withValues(alpha: 0.2),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Core Dissipation Efficiency',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                '99.4% Thermal Balance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 0.99,
                backgroundColor: Colors.black,
                color: Color(0xFF84CC16),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EcosystemCard extends StatelessWidget {
  final String zone, metrics;

  const EcosystemCard({super.key, required this.zone, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF84CC16).withValues(alpha: 0.15),
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
                  zone,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  metrics,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.eco, color: Color(0xFF84CC16), size: 20),
        ],
      ),
    );
  }
}