import 'package:flutter/material.dart';

void main() {
  runApp(const FitPulseApp());
}

class FitPulseApp extends StatelessWidget {
  const FitPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
      ),
      home: const FitHomeShell(),
    );
  }
}

class FitHomeShell extends StatefulWidget {
  const FitHomeShell({super.key});

  @override
  State<FitHomeShell> createState() => _FitHomeShellState();
}

class _FitHomeShellState extends State<FitHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkoutDashboardScreen(),
    ExerciseLibraryScreen(),
    UserProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: const Color(0xFF10B981).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF10B981)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.fitness_center, color: Color(0xFF10B981)),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Color(0xFF10B981)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: WORKOUT DASHBOARD ====================
class WorkoutDashboardScreen extends StatelessWidget {
  const WorkoutDashboardScreen({super.key});

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
                    Icon(Icons.bolt, color: Color(0xFF10B981), size: 28),
                    SizedBox(width: 8),
                    Text('FitPulse', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFF10B981)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF10B981)],
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
                      Text('TODAY\'S TARGET', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Upper Body Strength', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('45 Mins • 4 Exercises • 320 kcal', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Active Programs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ProgramTile(title: 'High Intensity Interval Training', level: 'Intermediate', duration: '30 mins'),
                ProgramTile(title: 'Core Stability & Abs', level: 'Beginner', duration: '20 mins'),
                ProgramTile(title: 'Heavy Hypertrophy Chest', level: 'Advanced', duration: '55 mins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgramTile extends StatelessWidget {
  final String title;
  final String level;
  final String duration;

  const ProgramTile({super.key, required this.title, required this.level, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.play_arrow, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 2),
                Text('$level • $duration', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: EXERCISE LIBRARY ====================
class ExerciseLibraryScreen extends StatelessWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Exercise Library', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 16),
            ExerciseTile(name: 'Barbell Bench Press', muscle: 'Chest & Triceps', sets: '4 Sets x 10 Reps'),
            ExerciseTile(name: 'Pull-Ups / Lat Pulldown', muscle: 'Back & Biceps', sets: '3 Sets x 12 Reps'),
            ExerciseTile(name: 'Barbell Back Squat', muscle: 'Legs & Glutes', sets: '4 Sets x 8 Reps'),
          ],
        ),
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String name;
  final String muscle;
  final String sets;

  const ExerciseTile({super.key, required this.name, required this.muscle, required this.sets});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              const SizedBox(height: 4),
              Text(muscle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(sets, style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: USER PROGRESS PROFILE ====================
class UserProgressScreen extends StatelessWidget {
  const UserProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Fitness Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF10B981),
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text('Alex Mercer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Goal: Muscle Gain • Streak: 12 Days', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileSettingTile(icon: Icons.monitor_weight, title: 'Weight & Body Metrics Tracker'),
            const ProfileSettingTile(icon: Icons.calendar_today, title: 'Workout History Log'),
            const ProfileSettingTile(icon: Icons.emoji_events, title: 'Badges & Achievements'),
            const ProfileSettingTile(icon: Icons.settings, title: 'App Settings & Sync'),
          ],
        ),
      ),
    );
  }
}

class ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileSettingTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF10B981)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}