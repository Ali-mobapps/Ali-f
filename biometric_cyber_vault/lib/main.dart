import 'package:flutter/material.dart';

void main() {
  runApp(const VaultTerminalApp());
}

class VaultTerminalApp extends StatelessWidget {
  const VaultTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Vault Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030712), // Deep Obsidian
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFB923C), // Cyber Amber / Warning Orange
          surface: const Color(0xFF111827),
        ),
      ),
      home: const VaultMasterShell(),
    );
  }
}

// ==================== UNIQUE MULTI-TAB SHELL ====================
class VaultMasterShell extends StatefulWidget {
  const VaultMasterShell({super.key});

  @override
  State<VaultMasterShell> createState() => _VaultMasterShellState();
}

class _VaultMasterShellState extends State<VaultMasterShell> {
  int _selectedTab = 0;

  final List<Widget> _terminalScreens = const [
    BiometricLockTab(),
    VaultInventoryTab(),
    AuditLogsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _terminalScreens[_selectedTab],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFB923C).withValues(alpha: 0.3),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _selectedTab,
            onTap: (index) => setState(() => _selectedTab = index),
            backgroundColor: const Color(0xFF111827),
            selectedItemColor: const Color(0xFFFB923C),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.fingerprint),
                label: 'Access',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shield_outlined),
                label: 'Vault Core',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.terminal_rounded),
                label: 'Logs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TAB 1: UNIQUE BIOMETRIC & ENCRYPTION GRID ====================
class BiometricLockTab extends StatefulWidget {
  const BiometricLockTab({super.key});

  @override
  State<BiometricLockTab> createState() => _BiometricLockTabState();
}

class _BiometricLockTabState extends State<BiometricLockTab> {
  bool _lockdownActive = true;
  bool _biometricBypass = false;
  double _securityLevel = 8.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'terminal access node // v4.2',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.5,
            color: Color(0xFFFB923C),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Unique Circular Status Indicator Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C2D12), Color(0xFF111827)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFB923C).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF030712),
                      border: Border.all(color: const Color(0xFFFB923C)),
                    ),
                    child: const Icon(
                      Icons.lock_person,
                      color: Color(0xFFFB923C),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIMARY VAULT GATE',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'SECURE [LEVEL 9]',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Custom Interactive Grid Actions instead of simple lists
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildGridActionCard(
                  title: 'Emergency Lock',
                  subtitle: _lockdownActive ? 'Engaged' : 'Disarmed',
                  icon: Icons.dangerous,
                  isActive: _lockdownActive,
                  onTap: () => setState(() => _lockdownActive = !_lockdownActive),
                ),
                _buildGridActionCard(
                  title: 'Bio-Bypass',
                  subtitle: _biometricBypass ? 'Enabled' : 'Restricted',
                  icon: Icons.how_to_reg,
                  isActive: _biometricBypass,
                  onTap: () => setState(() => _biometricBypass = !_biometricBypass),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quantum Encryption Threshold Slider
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFB923C).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Encryption Entropy Index',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${_securityLevel.toStringAsFixed(1)} Bits',
                        style: const TextStyle(
                          color: Color(0xFFFB923C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _securityLevel,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: const Color(0xFFFB923C),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _securityLevel = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E1B4B) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? const Color(0xFFFB923C) : Colors.grey.shade800,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFB923C), size: 22),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 2: VAULT INVENTORY ====================
class VaultInventoryTab extends StatelessWidget {
  const VaultInventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'secure asset compartments',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.5,
            color: Color(0xFFFB923C),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          VaultCompartmentCard(
            compartment: 'Alpha Vault [Encrypted Gold]',
            status: 'Sealed [100% Integrity]',
          ),
          SizedBox(height: 12),
          VaultCompartmentCard(
            compartment: 'Beta Vault [Neural Core Keys]',
            status: 'Sealed [100% Integrity]',
          ),
          SizedBox(height: 12),
          VaultCompartmentCard(
            compartment: 'Gamma Vault [Classified Archives]',
            status: 'Monitoring [Active]',
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 3: AUDIT LOGS ====================
class AuditLogsTab extends StatelessWidget {
  const AuditLogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'system audit trail',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.5,
            color: Color(0xFFFB923C),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFB923C).withValues(alpha: 0.2),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Intrusion Detection Status',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                'Zero Breaches Recorded in 72 Hours',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.black,
                color: Color(0xFFFB923C),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VaultCompartmentCard extends StatelessWidget {
  final String compartment, status;

  const VaultCompartmentCard({
    super.key,
    required this.compartment,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFB923C).withValues(alpha: 0.15),
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
                  compartment,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Color(0xFFFB923C), size: 20),
        ],
      ),
    );
  }
}