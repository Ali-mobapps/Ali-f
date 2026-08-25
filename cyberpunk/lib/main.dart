import 'package:flutter/material.dart';

void main() {
  runApp(const CyberMatrixApp());
}

class CyberMatrixApp extends StatelessWidget {
  const CyberMatrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    const neonMagenta = Color(0xFFEC4899); // Cyber Magenta Glow
    const voidBlack = Color(0xFF09050B); // Deep Matrix Void

    return MaterialApp(
      title: 'Neural Matrix Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: voidBlack,
        colorScheme: ColorScheme.dark(
          primary: neonMagenta,
          surface: const Color(0xFF130A17),
        ),
      ),
      home: const MatrixShell(),
    );
  }
}

// ==================== MATRIX SHELL ====================
class MatrixShell extends StatefulWidget {
  const MatrixShell({super.key});

  @override
  State<MatrixShell> createState() => _MatrixShellState();
}

class _MatrixShellState extends State<MatrixShell> {
  int _activeScreenIndex = 0;

  final List<Widget> _matrixTabs = const [
    NeuralSynapseTab(),
    MemoryStreamTab(),
    FirewallMatrixTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _matrixTabs[_activeScreenIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF130A17),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFEC4899).withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEC4899).withValues(alpha: 0.15),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _activeScreenIndex,
            onTap: (idx) => setState(() => _activeScreenIndex = idx),
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFFEC4899),
            unselectedItemColor: Colors.grey.shade600,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.psychology),
                label: 'Synapse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.blur_circular),
                label: 'Memory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.security),
                label: 'Firewall',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TAB 1: NEURAL SYNAPSE ====================
class NeuralSynapseTab extends StatefulWidget {
  const NeuralSynapseTab({super.key});

  @override
  State<NeuralSynapseTab> createState() => _NeuralSynapseTabState();
}

class _NeuralSynapseTabState extends State<NeuralSynapseTab> {
  bool _overclockMode = true;
  bool _deepSleepSync = false;
  double _neuralClockSpeed = 4.8; // GHz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'synapse-link v9.9 // neural interface',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.5,
            color: Color(0xFFEC4899),
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
            // Holographic Status Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF831843), Color(0xFF130A17)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYNAPTIC BANDWIDTH',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '128.4 TB/s [PEAK]',
                        style: TextStyle(
                          color: Color(0xFFEC4899),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.bolt, color: Color(0xFFEC4899), size: 36),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'cortical override modules',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Horizontal Cyber Pill Cards instead of grids or lists
            _buildCyberPillCard(
              title: 'Neural Overclocking',
              subtitle: _overclockMode ? 'Active [Multiplier 2.4x]' : 'Standard Safe Mode',
              icon: Icons.electric_bolt,
              value: _overclockMode,
              onChanged: (val) => setState(() => _overclockMode = val),
            ),
            const SizedBox(height: 12),
            _buildCyberPillCard(
              title: 'Deep REM Dream Sync',
              subtitle: _deepSleepSync ? 'Engaged [Subconscious Stream]' : 'Bypassed',
              icon: Icons.nightlight_round,
              value: _deepSleepSync,
              onChanged: (val) => setState(() => _deepSleepSync = val),
            ),
            const SizedBox(height: 20),

            // Frequency Slider
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF130A17),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Synapse Clock Frequency',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${_neuralClockSpeed.toStringAsFixed(1)} GHz',
                        style: const TextStyle(
                          color: Color(0xFFEC4899),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _neuralClockSpeed,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: const Color(0xFFEC4899),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _neuralClockSpeed = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCyberPillCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF130A17),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value ? const Color(0xFFEC4899) : Colors.grey.shade800,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEC4899), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFFEC4899),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 2: MEMORY STREAM ====================
class MemoryStreamTab extends StatelessWidget {
  const MemoryStreamTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'subconscious memory stream',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.5,
            color: Color(0xFFEC4899),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          MemoryBlockCard(cluster: 'Cluster Alpha [Encrypted Memory]', status: 'Archived // Read-Only'),
          SizedBox(height: 12),
          MemoryBlockCard(cluster: 'Cluster Beta [Synthetic Skill Index]', status: 'Streaming // Active'),
          SizedBox(height: 12),
          MemoryBlockCard(cluster: 'Cluster Gamma [Forgotten Archives]', status: 'Locked // Purged'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: FIREWALL MATRIX ====================
class FirewallMatrixTab extends StatelessWidget {
  const FirewallMatrixTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ice-breaker firewall defense',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.5,
            color: Color(0xFFEC4899),
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
            color: const Color(0xFF130A17),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFEC4899).withValues(alpha: 0.3),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BlackICE Intrusion Countermeasure',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                '100% Threat Neutralization',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.black,
                color: Color(0xFFEC4899),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemoryBlockCard extends StatelessWidget {
  final String cluster, status;

  const MemoryBlockCard({super.key, required this.cluster, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF130A17),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEC4899).withValues(alpha: 0.15),
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
                  cluster,
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
          const Icon(Icons.memory, color: Color(0xFFEC4899), size: 20),
        ],
      ),
    );
  }
}