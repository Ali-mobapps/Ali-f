import 'package:flutter/material.dart';

void main() {
  runApp(const BentoProductivityApp());
}

class BentoProductivityApp extends StatelessWidget {
  const BentoProductivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neural Bento UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090710), // Deep Void
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD946EF), // Neon Fuchsia
          surface: const Color(0xFF141021),
        ),
      ),
      home: const BentoDashboardScreen(),
    );
  }
}

// ==================== SCREEN 1: BENTO GRID DASHBOARD ====================
class BentoDashboardScreen extends StatelessWidget {
  const BentoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('neural matrix', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFFD946EF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.hub, color: Color(0xFFD946EF)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NeuralAnalyticsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Wide Bento Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NeuralAnalyticsScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF701A75), Color(0xFFD946EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: 28),
                    SizedBox(height: 16),
                    Text('Core Sync Active', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Neural Synchronization at 98.4%', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Middle Bento Row (2 Split Cards)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141021),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD946EF).withValues(alpha: 0.2)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.memory, color: Color(0xFFD946EF), size: 28),
                        Spacer(),
                        Text('Memory', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('64 TB RAM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141021),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD946EF).withValues(alpha: 0.2)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.security, color: Color(0xFFD946EF), size: 28),
                        Spacer(),
                        Text('Shield', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Active 100%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Tall Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141021),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD946EF).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090710),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.radar, color: Color(0xFFD946EF)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deep Scanner Protocol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Zero anomalies detected in sector 7', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: NEURAL ANALYTICS MATRIX ====================
class NeuralAnalyticsScreen extends StatelessWidget {
  const NeuralAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('analytics matrix', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD946EF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD946EF)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF141021),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD946EF).withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantum Core Processor', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Frequency: 4.8 GHz Optimized', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.88,
                    backgroundColor: Color(0xFF090710),
                    color: Color(0xFFD946EF),
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Sub-System Diagnostics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const DiagnosticCard(title: 'Synapse Latency', status: '0.12 ms'),
            const SizedBox(height: 10),
            const DiagnosticCard(title: 'Quantum Flux', status: 'Stable'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD946EF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('recalibrate core', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticCard extends StatelessWidget {
  final String title, status;

  const DiagnosticCard({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141021),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD946EF).withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(status, style: const TextStyle(color: Color(0xFFD946EF), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}