import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCCFF00),
          brightness: Brightness.dark,
        ),
      ),
      home: const FitnessHomeShell(),
    );
  }
}

class FitnessHomeShell extends StatefulWidget {
  const FitnessHomeShell({super.key});

  @override
  State<FitnessHomeShell> createState() => _FitnessHomeShellState();
}

class _FitnessHomeShellState extends State<FitnessHomeShell> {
  int _currentIndex = 0;

  // 3 Mukammal Screens jo bottom navigation se open hongi
  final List<Widget> _screens = const [
    ActivitySummaryScreen(),
    WorkoutsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1A1A1A),
        indicatorColor: const Color(0xFFCCFF00).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.local_fire_department, color: Color(0xFFCCFF00)),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.fitness_center, color: Color(0xFFCCFF00)),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Color(0xFFCCFF00)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: ACTIVITY SUMMARY ====================
class ActivitySummaryScreen extends StatelessWidget {
  const ActivitySummaryScreen({super.key});

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
                    Icon(Icons.bolt, color: Color(0xFFCCFF00), size: 28),
                    SizedBox(width: 8),
                    Text('ApexFit Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFFCCFF00)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F1F1F), Color(0xFF2C2C2C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCCFF00).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('DAILY CALORIE GOAL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('1,840 / 2,200', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('🔥 360 kcal left to burn', style: TextStyle(color: Color(0xFFCCFF00), fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.local_fire_department, color: Color(0xFFCCFF00), size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Metrics Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                MetricBox(title: 'Steps Walked', value: '8,432', subtitle: 'Goal: 10k'),
                MetricBox(title: 'Active Time', value: '64 mins', subtitle: 'Target: 60m'),
                MetricBox(title: 'Water Intake', value: '2.4 L', subtitle: 'Goal: 3.0L'),
                MetricBox(title: 'Heart Rate', value: '72 bpm', subtitle: 'Resting avg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MetricBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const MetricBox({super.key, required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: WORKOUTS & PLANS ====================
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Workout Routines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 16),
            WorkoutTile(title: 'HIIT Fat Burner', duration: '45 mins', calories: '450 kcal', level: 'High Intensity'),
            WorkoutTile(title: 'Upper Body Hypertrophy', duration: '60 mins', calories: '380 kcal', level: 'Strength'),
            WorkoutTile(title: 'Core & Mobility Flow', duration: '30 mins', calories: '200 kcal', level: 'Flexibility'),
          ],
        ),
      ),
    );
  }
}

class WorkoutTile extends StatelessWidget {
  final String title;
  final String duration;
  final String calories;
  final String level;

  const WorkoutTile({super.key, required this.title, required this.duration, required this.calories, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFCCFF00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: Color(0xFFCCFF00)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const SizedBox(height: 2),
                Text('$duration • $level', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(calories, style: const TextStyle(color: Color(0xFFCCFF00), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: USER PROFILE ====================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFCCFF00),
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text('Alex Morgan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Pro Member • Weight: 74 kg', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileOptionTile(icon: Icons.settings, title: 'App Settings'),
            const ProfileOptionTile(icon: Icons.monitor_weight, title: 'Body Measurement History'),
            const ProfileOptionTile(icon: Icons.shield, title: 'Privacy & Permissions'),
            const ProfileOptionTile(icon: Icons.logout, title: 'Log Out'),
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFCCFF00)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}