// File path: lib/features/tasks/presentation/pages/tasks_page.dart
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _selectedTab = 1; // 0: All, 1: Ongoing, 2: Completed
  String _searchQuery = '';

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'UI/UX Design Review',
      'due': 'Due: 25 Jul 2026',
      'priority': 'High',
      'color': Colors.red,
      'isCompleted': false,
    },
    {
      'title': 'API Integration',
      'due': 'Due: 27 Jul 2026',
      'priority': 'Medium',
      'color': Colors.orange,
      'isCompleted': false,
    },
    {
      'title': 'Testing & Bug Fixing',
      'due': 'Due: 30 Jul 2026',
      'priority': 'Low',
      'color': Colors.green,
      'isCompleted': false,
    },
    {
      'title': 'Client Meeting',
      'due': 'Due: 02 Aug 2026',
      'priority': 'High',
      'color': Colors.red,
      'isCompleted': true,
    },
  ];

  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: Text(task['title'], style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['due'], style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Priority: ', style: TextStyle(color: Colors.white70)),
                Text(task['priority'], style: TextStyle(color: task['color'], fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(color: Colors.white70)),
                Text(
                  task['isCompleted'] ? 'Completed' : 'Ongoing',
                  style: TextStyle(color: task['isCompleted'] ? Colors.green : Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
            onPressed: () {
              setState(() {
                task['isCompleted'] = !task['isCompleted'];
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task status updated!')),
              );
            },
            child: Text(
              task['isCompleted'] ? 'Mark Uncompleted' : 'Mark Completed',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tasks.where((task) {
      final matchesSearch = task['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedTab == 0) return matchesSearch;
      if (_selectedTab == 1) return matchesSearch && !task['isCompleted'];
      if (_selectedTab == 2) return matchesSearch && task['isCompleted'];
      return matchesSearch;
    }).toList();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton('All', 0),
                _buildTabButton('Ongoing', 1),
                _buildTabButton('Completed', 2),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                child: Text('No tasks found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              )
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _showTaskDetails(task),
                      leading: Icon(
                        task['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task['isCompleted'] ? Colors.green : const Color(0xFF0052CC),
                      ),
                      title: Text(
                        task['title'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        task['due'],
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: task['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task['priority'],
                          style: TextStyle(color: task['color'], fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: Colors.blueAccent,
            ),
        ],
      ),
    );
  }
}