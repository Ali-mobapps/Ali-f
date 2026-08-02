import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task_model.dart';
import 'providers/task_provider.dart';
import 'views/home_screen.dart';

void main() async {
  // Hive initialization ke liye WidgetsFlutterBinding zaroori hai
  WidgetsFlutterBinding.ensureInitialized();

  // Hive ko init karein
  await Hive.initFlutter();

  // Custom Task adapter register karein jo step 2 mein bana hai
  Hive.registerAdapter(TaskAdapter());

  // 'tasks_box' ke naam se box (database) open karein
  await Hive.openBox<Task>('tasks_box');

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}