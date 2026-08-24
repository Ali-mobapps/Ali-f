import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Slate Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF10B981), // Emerald Green Accent
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const TaskHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: HOME & TASK LIST ====================
class TaskHomeScreen extends StatelessWidget {
  const TaskHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('my workspace', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('vip productivity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF1E293B),
              child: Icon(Icons.add, color: Color(0xFF10B981)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskDetailScreen()),
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
            // Progress Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('today progress', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('8 of 10 Tasks Completed', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: Colors.black26,
                    color: Colors.white,
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ongoing tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TaskDetailScreen()),
                    );
                  },
                  child: const Text('view analytics ->', style: TextStyle(color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Task Tiles
            const TaskTile(title: 'Flutter UI Architecture', subtitle: 'Design System & Widgets', time: '10:00 AM', isDone: true),
            const SizedBox(height: 10),
            const TaskTile(title: 'Backend API Integration', subtitle: 'Firebase Auth & Cloud Firestore', time: '02:30 PM', isDone: false),
            const SizedBox(height: 10),
            const TaskTile(title: 'Client Project Review', subtitle: 'Discuss Milestones & Feedback', time: '05:00 PM', isDone: false),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: TASK DETAILS & ANALYTICS ====================
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('task analytics', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
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
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Weekly Productivity Rate', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 10),
                  Text('92% Efficiency Score 🚀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 16),
                  Text('You have maintained a consistent streak of completing tasks ahead of deadlines this week.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Performance Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const StatRow(category: 'Development Tasks', count: '14 Completed', color: Colors.blue),
            const SizedBox(height: 8),
            const StatRow(category: 'Design & Wireframes', count: '8 Completed', color: Colors.purple),
            const SizedBox(height: 8),
            const StatRow(category: 'Meetings & Strategy', count: '5 Completed', color: Colors.orange),
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
class TaskTile extends StatelessWidget {
  final String title, subtitle, time;
  final bool isDone;

  const TaskTile({super.key, required this.title, required this.subtitle, required this.time, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? const Color(0xFF10B981) : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String category, count;
  final Color color;

  const StatRow({super.key, required this.category, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          Text(count, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}