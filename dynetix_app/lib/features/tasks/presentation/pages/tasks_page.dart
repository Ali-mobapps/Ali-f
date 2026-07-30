// File path: lib/features/tasks/presentation/pages/tasks_page.dart
import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tasks = [
      {'title': 'UI/UX Design Review', 'due': 'Due: 25 Jul 2026', 'priority': 'High'},
      {'title': 'API Integration', 'due': 'Due: 27 Jul 2026', 'priority': 'Medium'},
      {'title': 'Testing & Bug Fixing', 'due': 'Due: 30 Jul 2026', 'priority': 'Low'},
      {'title': 'Client Meeting', 'due': 'Due: 01 Aug 2026', 'priority': 'High'},
      {'title': 'Documentation', 'due': 'Due: 03 Aug 2026', 'priority': 'Medium'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tabs: All, Ongoing, Completed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('All', style: TextStyle(color: Colors.grey)),
                Text('Ongoing', style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                Text('Completed', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  Color priorityColor = Colors.green;
                  if (task['priority'] == 'High') priorityColor = Colors.red;
                  if (task['priority'] == 'Medium') priorityColor = Colors.orange;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.task_alt, color: Color(0xFF0052CC), size: 28),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  task['due']!,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task['priority']!,
                            style: TextStyle(color: priorityColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}