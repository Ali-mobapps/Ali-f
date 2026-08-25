import 'package:flutter/material.dart';

void main() {
  runApp(const PrivateJetApp());
}

class PrivateJetApp extends StatelessWidget {
  const PrivateJetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIP Jet Charter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C0C0E), // Deep Jet Black
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD4AF37), // Metallic Gold Accent
          surface: const Color(0xFF16161A),
        ),
      ),
      home: const JetShell(),
    );
  }
}

// ==================== JET SHELL WITH BOTTOM NAVIGATION ====================
class JetShell extends StatefulWidget {
  const JetShell({super.key});

  @override
  State<JetShell> createState() => _JetShellState();
}

class _JetShellState extends State<JetShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CharterSearchTab(),
    FleetFleetTab(),
    ConciergeTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: 'Charter'),
            BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: 'Our Fleet'),
            BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Concierge'),
          ],
        ),
      ),
    );
  }
}

// ==================== TAB 1: CHARTER SEARCH & CONFIG ====================
class CharterSearchTab extends StatefulWidget {
  const CharterSearchTab({super.key});

  @override
  State<CharterSearchTab> createState() => _CharterSearchTabState();
}

class _CharterSearchTabState extends State<CharterSearchTab> {
  bool _cateringIncluded = true;
  bool _groundTransfer = true;
  double _passengerCount = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aviation elite concierge', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFD4AF37))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight Route Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5A4A1A), Color(0xFFD4AF37)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FEATURED ROUTE', style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  SizedBox(height: 6),
                  Text('New York (JFK) -> Geneva (GVA)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  Text('Gulfstream G650ER • Ready for Departure', style: TextStyle(color: Colors.black87, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('flight customization', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Toggle 1
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.restaurant, color: Color(0xFFD4AF37)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Michelin Star Catering', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Custom dietary menu included', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _cateringIncluded,
                    activeThumbColor: const Color(0xFFD4AF37),
                    onChanged: (val) => setState(() => _cateringIncluded = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Toggle 2
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.directions_car, color: Color(0xFFD4AF37)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('VIP Tarmac Transfer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Rolls-Royce pickup service', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _groundTransfer,
                    activeThumbColor: const Color(0xFFD4AF37),
                    onChanged: (val) => setState(() => _groundTransfer = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Passenger Slider
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Passenger Manifest Count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${_passengerCount.toInt()} Guests', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _passengerCount,
                    min: 1,
                    max: 14,
                    divisions: 13,
                    activeColor: const Color(0xFFD4AF37),
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) => setState(() => _passengerCount = val),
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

// ==================== TAB 2: OUR FLEET ====================
class FleetFleetTab extends StatelessWidget {
  const FleetFleetTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aircraft catalog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFD4AF37))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FleetCard(name: 'Gulfstream G650ER', range: '7,500 nm • 19 Seats', speed: 'Mach 0.925'),
          SizedBox(height: 12),
          FleetCard(name: 'Bombardier Global 7500', range: '7,700 nm • 17 Seats', speed: 'Mach 0.925'),
          SizedBox(height: 12),
          FleetCard(name: 'Dassault Falcon 8X', range: '6,450 nm • 14 Seats', speed: 'Mach 0.90'),
        ],
      ),
    );
  }
}

// ==================== TAB 3: CONCIERGE ====================
class ConciergeTab extends StatelessWidget {
  const ConciergeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('personal flight manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFD4AF37))),
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
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dedicated Flight Broker', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 6),
                  Text('Alistair Vance [Global Dispatch]', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Secure Direct Line: +1 (800) 555-JET1', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FleetCard extends StatelessWidget {
  final String name, range, speed;

  const FleetCard({super.key, required this.name, required this.range, required this.speed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(range, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(speed, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}