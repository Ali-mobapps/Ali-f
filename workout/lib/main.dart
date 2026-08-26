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
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE2F163), brightness: Brightness.dark),
      ),
      home: const FitnessHomeScreen(),
    );
  }
}

class FitnessHomeScreen extends StatefulWidget {
  const FitnessHomeScreen({super.key});

  @override
  State<FitnessHomeScreen> createState() => _FitnessHomeScreenState();
}

class _FitnessHomeScreenState extends State<FitnessHomeScreen> with SingleTickerProviderStateMixin {
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
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE2F163),
              child: Text('🔥', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Goal', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text('Workout & Diet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.bolt, color: Color(0xFFE2F163)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFE2F163),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Workouts'),
                Tab(text: 'Diet & Macros'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WorkoutsTab(),
          DietMacrosTab(),
        ],
      ),
    );
  }
}

class WorkoutsTab extends StatelessWidget {
  const WorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity Summary Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2F163).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Calories Burned', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('1,420 kcal', style: TextStyle(color: Color(0xFFE2F163), fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Target: 1,800 kcal • 78% done', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
                const Icon(Icons.local_fire_department, color: Color(0xFFE2F163), size: 48),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Today\'s Routine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              WorkoutTile(title: 'Upper Body Strength', duration: '45 mins • 12 Exercises', icon: Icons.fitness_center, color: Color(0xFFE2F163)),
              WorkoutTile(title: 'High Intensity Cardio', duration: '25 mins • 6 Exercises', icon: Icons.directions_run, color: Colors.orangeAccent),
              WorkoutTile(title: 'Core & Abs Burner', duration: '20 mins • 8 Exercises', icon: Icons.sports_gymnastics, color: Colors.cyanAccent),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkoutTile extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final Color color;

  const WorkoutTile({super.key, required this.title, required this.duration, required this.icon, required this.color});

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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const SizedBox(height: 3),
                Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}

class DietMacrosTab extends StatelessWidget {
  const DietMacrosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Macronutrients Intake', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: const [
                MacroProgressBar(label: 'Protein (140g / 180g)', progress: 0.75, color: Colors.cyanAccent),
                SizedBox(height: 16),
                MacroProgressBar(label: 'Carbs (210g / 250g)', progress: 0.84, color: Color(0xFFE2F163)),
                SizedBox(height: 16),
                MacroProgressBar(label: 'Fats (50g / 70g)', progress: 0.70, color: Colors.orangeAccent),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Meal Planner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              MealCard(meal: 'Breakfast', food: 'Oats, Peanut Butter & Banana', calories: '450 kcal', isDone: true),
              MealCard(meal: 'Lunch', food: 'Grilled Chicken & Brown Rice', calories: '650 kcal', isDone: true),
              MealCard(meal: 'Dinner', food: 'Salmon, Avocado & Asparagus', calories: '550 kcal', isDone: false),
            ],
          ),
        ],
      ),
    );
  }
}

class MacroProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;

  const MacroProgressBar({super.key, required this.label, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.black54,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class MealCard extends StatelessWidget {
  final String meal;
  final String food;
  final String calories;
  final bool isDone;

  const MealCard({super.key, required this.meal, required this.food, required this.calories, required this.isDone});

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
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? const Color(0xFFE2F163) : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const SizedBox(height: 2),
                Text(food, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(calories, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2F163), fontSize: 13)),
        ],
      ),
    );
  }
}