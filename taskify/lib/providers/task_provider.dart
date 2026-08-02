import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasks_box');
  String _searchQuery = '';

  // Total tasks count
  int get totalTasks => _taskBox.values.length;

  // Completed tasks count
  int get completedTasks => _taskBox.values.where((task) => task.isCompleted).length;

  // Search query ke mutabiq filtered tasks return karein
  List<Task> get tasks {
    final allTasks = _taskBox.values.toList().cast<Task>();
    if (_searchQuery.isEmpty) {
      return allTasks;
    }
    return allTasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Search text update karne ke liye method
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addTask(String title, String category, String description) {
    final newTask = Task(
      id: DateTime.now().toString(), // Unique ID
      title: title,
      category: category,
      date: DateTime.now(),
      description: description, // Description yahan pass hogi
    );

    // Naya task Hive box mein add karein
    _taskBox.add(newTask);
    notifyListeners();
  }

  void toggleTask(int index) {
    // Original box index nikalne ke liye
    final currentTask = tasks[index];
    final actualIndex = _taskBox.values.toList().cast<Task>().indexOf(currentTask);

    if (actualIndex != -1) {
      final task = _taskBox.getAt(actualIndex);
      if (task != null) {
        task.isCompleted = !task.isCompleted;
        task.save(); // Direct save method use kar sakte hain kyunki Task HiveObject extend karta hai
        notifyListeners();
      }
    }
  }

  void deleteTask(int index) {
    final currentTask = tasks[index];
    final actualIndex = _taskBox.values.toList().cast<Task>().indexOf(currentTask);

    if (actualIndex != -1) {
      _taskBox.deleteAt(actualIndex);
      notifyListeners();
    }
  }
}