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
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8B3D)),
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

class _PetHomeScreenState extends State<PetHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.pets, color: Color(0xFFFF8B3D), size: 24),
            SizedBox(width: 8),
            Text('Paws & Claws Care', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2B2B2B))),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_active_outlined, color: Color(0xFF2B2B2B)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD8),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFFF8B3D),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF8A7968),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'My Pets & Health'),
                Tab(text: 'Vet Appointments'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PetsHealthTab(),
          VetAppointmentsTab(),
        ],
      ),
    );
  }
}

class PetsHealthTab extends StatelessWidget {
  const PetsHealthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Profile Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8B3D), Color(0xFFFFB074)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF8B3D).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cruelty_free, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Max • Golden Retriever', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Age: 3 Years • Weight: 28 kg', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('Next Vaccination in 14 days', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Daily Care Routine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2B2B2B))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              RoutineTaskTile(task: 'Morning Walk & Exercise', time: '07:30 AM', isDone: true),
              RoutineTaskTile(task: 'Breakfast Feeding (Dry Food)', time: '08:30 AM', isDone: true),
              RoutineTaskTile(task: 'Vitamin Supplement', time: '01:00 PM', isDone: false),
              RoutineTaskTile(task: 'Evening Park Play', time: '05:30 PM', isDone: false),
            ],
          ),
        ],
      ),
    );
  }
}

class RoutineTaskTile extends StatelessWidget {
  final String task;
  final String time;
  final bool isDone;

  const RoutineTaskTile({super.key, required this.task, required this.time, required this.isDone});

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
            color: isDone ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2B2B2B), decoration: isDone ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Color(0xFF8A7968), fontSize: 12)),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Vet Visit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2B2B2B))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8B3D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_hospital, color: Color(0xFFFF8B3D), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Dr. Sarah Smith, DVM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2B2B2B))),
                      SizedBox(height: 2),
                      Text('General Checkup & Dental', style: TextStyle(fontSize: 12, color: Color(0xFF8A7968))),
                      SizedBox(height: 2),
                      Text('Sept 12, 2026 • 11:00 AM', style: TextStyle(fontSize: 11, color: Color(0xFFFF8B3D), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Available Specialists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2B2B2B))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              VetCard(name: 'Dr. John Watson', specialization: 'Pet Surgeon & Orthopedics', rating: '4.9'),
              VetCard(name: 'Dr. Emily Blunt', specialization: 'Dermatology & Grooming', rating: '4.8'),
            ],
          ),
        ],
      ),
    );
  }
}

class VetCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String rating;

  const VetCard({super.key, required this.name, required this.specialization, required this.rating});

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8B3D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFFFF8B3D)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2B2B2B))),
                const SizedBox(height: 2),
                Text(specialization, style: const TextStyle(color: Color(0xFF8A7968), fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}