import 'package:flutter/material.dart';

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F9F6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
      ),
      home: const PetHomeScreen(),
    );
  }
}

class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  State<PetHomeScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PetDashboardTab(),
    const VetAppointmentsTab(),
    const PetProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF0D9488).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets, color: Color(0xFF0D9488)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services, color: Color(0xFF0D9488)),
            label: 'Vets',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF0D9488)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PetDashboardTab extends StatelessWidget {
  const PetDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFF0D9488),
                      child: Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Max’s Owner 🐾', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1F2937))),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: Color(0xFF0D9488)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Active Pet Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
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
                      Text('ACTIVE PET PROFILE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Max (Golden Retriever)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Age: 3 yrs • Weight: 28 kg', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.favorite, color: Colors.white, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Daily Care Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 12),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                PetTaskTile(title: 'Morning Walk', time: '07:30 AM', isDone: true),
                PetTaskTile(title: 'Vitamins & Supplements', time: '01:00 PM', isDone: false),
                PetTaskTile(title: 'Evening Park Play', time: '05:30 PM', isDone: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PetTaskTile extends StatelessWidget {
  final String title;
  final String time;
  final bool isDone;

  const PetTaskTile({super.key, required this.title, required this.time, required this.isDone});

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
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? const Color(0xFF0D9488) : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F2937), decoration: isDone ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VetAppointmentsTab extends StatelessWidget {
  const VetAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Vet Appointments Screen', style: TextStyle(color: Color(0xFF1F2937))));
  }
}

class PetProfileTab extends StatelessWidget {
  const PetProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Pet Profile Screen', style: TextStyle(color: Color(0xFF1F2937))));
  }
}