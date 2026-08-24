import 'package:flutter/material.dart';

void main() {
  runApp(const HealthcareApp());
}

class HealthcareApp extends StatelessWidget {
  const HealthcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF061A1D), // Deep Medical Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00E5FF), // Medical Cyan Accent
          surface: const Color(0xFF0E2A30),
        ),
      ),
      home: const HealthHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: DOCTORS & HEALTH DASHBOARD ====================
class HealthHomeScreen extends StatelessWidget {
  const HealthHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('good morning', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('dr. alexander vip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF0E2A30),
              child: Icon(Icons.calendar_today, color: Color(0xFF00E5FF)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppointmentDetailScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007A87), Color(0xFF00E5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('upcoming consultation', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Cardiology Checkup\nToday at 03:30 PM', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppointmentDetailScreen()),
                      );
                    },
                    child: const Text('view appointment', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('top specialists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentDetailScreen()),
                    );
                  },
                  child: const Text('see all ->', style: TextStyle(color: Color(0xFF00E5FF))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Doctor Tiles
            const DoctorTile(name: 'Dr. Sarah Jenkins', specialty: 'Senior Cardiologist', rating: '4.9', patients: '1.2k+'),
            const SizedBox(height: 10),
            const DoctorTile(name: 'Dr. Michael Chen', specialty: 'Neurology Specialist', rating: '4.8', patients: '980+'),
            const SizedBox(height: 10),
            const DoctorTile(name: 'Dr. Emily Watson', specialty: 'Pediatric Surgeon', rating: '4.95', patients: '2.1k+'),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: APPOINTMENT DETAILS & SCHEDULE ====================
class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('consultation details', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00E5FF)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0E2A30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Doctor Profile', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 10),
                  Text('Dr. Sarah Jenkins, M.D.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 6),
                  Text('Lead Cardiologist • City General Hospital', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13)),
                  SizedBox(height: 16),
                  Text('Specialized in advanced heart care, preventive cardiology, and post-surgery rehabilitation protocols.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Available Time Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const SlotRow(time: '02:00 PM - 02:30 PM', status: 'Available'),
            const SizedBox(height: 8),
            const SlotRow(time: '03:30 PM - 04:00 PM', status: 'Booked'),
            const SizedBox(height: 8),
            const SlotRow(time: '05:00 PM - 05:30 PM', status: 'Available'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('back to dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class DoctorTile extends StatelessWidget {
  final String name, specialty, rating, patients;

  const DoctorTile({super.key, required this.name, required this.specialty, required this.rating, required this.patients});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2A30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF061A1D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services, color: Color(0xFF00E5FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text(patients, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class SlotRow extends StatelessWidget {
  final String time, status;

  const SlotRow({super.key, required this.time, required this.status});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = status == 'Available';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2A30),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF00E5FF), size: 18),
              const SizedBox(width: 12),
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              color: isAvailable ? const Color(0xFF00E5FF) : Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}