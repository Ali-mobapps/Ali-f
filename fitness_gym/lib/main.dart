import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117), // Deep Obsidian Fitness Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF10B981), // Emerald Neon Green Accent
          surface: const Color(0xFF161B22),
        ),
      ),
      home: const FitnessHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: FITNESS DASHBOARD ====================
class FitnessHomeScreen extends StatelessWidget {
  const FitnessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('daily goal: 85%', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('vip elite training', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF161B22),
              child: Icon(Icons.bolt, color: Color(0xFF10B981)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutDetailScreen()),
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
            // Promo Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('advanced routine', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('High-Intensity Hypertrophy\nCore & Upper Body Shred', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(builder: (context) => const WorkoutDetailScreen()),
                      );
                    },
                    child: const Text('start workout', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('todays exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkoutDetailScreen()),
                    );
                  },
                  child: const Text('view plan ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Exercise Tiles
            const ExerciseTile(name: 'Barbell Bench Press', sets: '4 Sets • 10 Reps', calories: '320 kcal', isCompleted: true),
            const SizedBox(height: 10),
            const ExerciseTile(name: 'Incline Dumbbell Flyes', sets: '3 Sets • 12 Reps', calories: '210 kcal', isCompleted: true),
            const SizedBox(height: 10),
            const ExerciseTile(name: 'Weighted Cable Crossovers', sets: '4 Sets • 15 Reps', calories: '250 kcal', isCompleted: false),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: WORKOUT DETAILS & METRICS ====================
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('workout session details', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF10B981)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Session Status', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Hypertrophy Day 3 • Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Duration: 55 Mins', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      Text('Burn: 780 kcal', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Performance Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const MetricRow(label: 'Average Heart Rate', value: '142 BPM'),
            const SizedBox(height: 8),
            const MetricRow(label: 'Peak Intensity', value: '175 BPM'),
            const SizedBox(height: 8),
            const MetricRow(label: 'Rest Intervals', value: '60 Seconds'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('complete session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class ExerciseTile extends StatelessWidget {
  final String name, sets, calories;
  final bool isCompleted;

  const ExerciseTile({super.key, required this.name, required this.sets, required this.calories, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.fitness_center,
              color: isCompleted ? const Color(0xFF10B981) : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(sets, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(calories, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 14)),
        ],
      ),
    );
  }
}

class MetricRow extends StatelessWidget {
  final String label, value;

  const MetricRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}