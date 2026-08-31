import 'package:flutter/material.dart';

void main() {
  runApp(const MedConnectApp());
}

class MedConnectApp extends StatelessWidget {
  const MedConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7)),
      ),
      home: const MedHomeShell(),
    );
  }
}

class MedHomeShell extends StatefulWidget {
  const MedHomeShell({super.key});

  @override
  State<MedHomeShell> createState() => _MedHomeShellState();
}

class _MedHomeShellState extends State<MedHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FindDoctorsScreen(),
    AppointmentsScreen(),
    PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF0284C7).withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: Color(0xFF0284C7)),
            label: 'Doctors',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: Color(0xFF0284C7)),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF0284C7)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: FIND DOCTORS ====================
class FindDoctorsScreen extends StatelessWidget {
  const FindDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.local_hospital, color: Color(0xFF0284C7), size: 28),
                    SizedBox(width: 8),
                    Text('MedConnect', style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFF0284C7)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('24/7 ONLINE CARE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Consult Top Specialists', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Connect in under 5 minutes', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.video_call, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Featured Specialists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DoctorTile(name: 'Dr. Sarah Jenkins', specialty: 'Cardiologist', rating: '4.9', experience: '10 yrs exp'),
                DoctorTile(name: 'Dr. Michael Chen', specialty: 'Neurologist', rating: '4.8', experience: '12 yrs exp'),
                DoctorTile(name: 'Dr. Ayesha Malik', specialty: 'Dermatologist', rating: '5.0', experience: '8 yrs exp'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;
  final String experience;

  const DoctorTile({super.key, required this.name, required this.specialty, required this.rating, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text('$specialty • $experience', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: APPOINTMENTS ====================
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('My Appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            SizedBox(height: 16),
            AppointmentTile(doctor: 'Dr. Sarah Jenkins', type: 'Video Consultation', date: 'Tomorrow, 10:30 AM', status: 'Confirmed'),
            AppointmentTile(doctor: 'Dr. Ayesha Malik', type: 'In-Clinic Checkup', date: 'Oct 14, 03:00 PM', status: 'Pending'),
          ],
        ),
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final String doctor;
  final String type;
  final String date;
  final String status;

  const AppointmentTile({super.key, required this.doctor, required this.type, required this.date, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(type, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: status == 'Confirmed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(color: status == 'Confirmed' ? Colors.green : Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: PATIENT PROFILE ====================
class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Patient Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF0284C7),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('John Doe', style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Blood Group: O+ • Age: 29', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileOptionTile(icon: Icons.medical_information, title: 'Medical History'),
            const ProfileOptionTile(icon: Icons.receipt_long, title: 'Prescriptions & Reports'),
            const ProfileOptionTile(icon: Icons.payment, title: 'Payment Methods'),
            const ProfileOptionTile(icon: Icons.settings, title: 'Account Settings'),
          ],
        ),
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileOptionTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0284C7)),
        title: Text(title, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}