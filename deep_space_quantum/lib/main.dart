import 'package:flutter/material.dart';

void main() {
  runApp(const QuantumSpaceApp());
}

class QuantumSpaceApp extends StatelessWidget {
  const QuantumSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Interstellar Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF04060B), // Deep Cosmos Void
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF8B5CF6), // Interstellar Violet / Quantum Glow
          surface: const Color(0xFF0F172A),
        ),
      ),
      home: const QuantumShell(),
    );
  }
}

// ==================== QUANTUM SHELL ====================
class QuantumShell extends StatefulWidget {
  const QuantumShell({super.key});

  @override
  State<QuantumShell> createState() => _QuantumShellState();
}

class _QuantumShellState extends State<QuantumShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    EntanglementTab(),
    RelayNodesTab(),
    QuantumDiagnosticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF8B5CF6),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.hub),
              label: 'Entanglement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_antenna),
              label: 'Relay Nodes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_moon),
              label: 'Diagnostics',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 1: ENTANGLEMENT DESK ====================
class EntanglementTab extends StatefulWidget {
  const EntanglementTab({super.key});

  @override
  State<EntanglementTab> createState() => _EntanglementTabState();
}

class _EntanglementTabState extends State<EntanglementTab> {
  bool _qubitSync = true;
  bool _tachyonShield = true;
  double _baudRate = 98.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'deep-space quantum entanglement matrix',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF8B5CF6),
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
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INTERSTELLAR LINK STABILITY',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '99.998% COHERENCE',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF04060B),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        'LOCKED',
                        style: TextStyle(
                          color: Colors.purpleAccent,
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
              'sub-atomic routing controls',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.grain, color: Color(0xFF8B5CF6)),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qubit Coherence Lock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Continuous phase synchronization',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _qubitSync,
                    activeThumbColor: const Color(0xFF8B5CF6),
                    onChanged: (val) => setState(() => _qubitSync = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: Color(0xFF8B5CF6)),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tachyon Field Shielding',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Nullifying cosmic ray interference',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _tachyonShield,
                    activeThumbColor: const Color(0xFF8B5CF6),
                    onChanged: (val) => setState(() => _tachyonShield = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantum Transmission Bandwidth',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${_baudRate.toStringAsFixed(1)} TB/s',
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _baudRate,
                    min: 10.0,
                    max: 200.0,
                    divisions: 19,
                    activeColor: const Color(0xFF8B5CF6),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _baudRate = val),
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

// ==================== TAB 2: RELAY NODES ====================
class RelayNodesTab extends StatelessWidget {
  const RelayNodesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'deep-space relay nodes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF8B5CF6),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          NodeRowCard(node: 'Alpha Centauri Gateway', status: 'Online [Latency: 4.2ms]'),
          SizedBox(height: 10),
          NodeRowCard(node: 'Proxima Station Relayer', status: 'Online [Latency: 6.8ms]'),
          SizedBox(height: 10),
          NodeRowCard(node: 'Sol-System Outpost Beta', status: 'Synchronizing [0.1ms]'),
          SizedBox(height: 10),
          NodeRowCard(node: 'Deep Void Sentinel Array', status: 'Standby [Secured]'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: QUANTUM DIAGNOSTICS ====================
class QuantumDiagnosticsTab extends StatelessWidget {
  const QuantumDiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sub-atomic integrity audit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF8B5CF6),
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
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entropy Decryption Index',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Zero Data Loss [100% Secure]',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.black,
                    color: Color(0xFF8B5CF6),
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

class NodeRowCard extends StatelessWidget {
  final String node, status;

  const NodeRowCard({super.key, required this.node, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            node,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}