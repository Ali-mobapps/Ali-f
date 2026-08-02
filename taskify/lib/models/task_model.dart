import 'package:hive/hive.dart';

// Yeh line zaroori hai, taake build_runner yahan se generated code utha sakay
part 'task_model.g.dart';

@HiveType(typeId: 0) // typeId unique hona chahiye har model ke liye
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  final String description; // Nayi description field

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    this.isCompleted = false,
    this.description = '',
  });
}