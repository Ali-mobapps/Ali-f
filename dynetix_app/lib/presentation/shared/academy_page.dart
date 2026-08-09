import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/supabase_service.dart';

class AcademyPage extends StatefulWidget {
  final bool isAdmin;
  const AcademyPage({super.key, required this.isAdmin});

  @override
  State<AcademyPage> createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      setState(() => _isLoading = true);
      final data = await SupabaseService.getItems('courses');
      setState(() {
        _courses = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Academy Courses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        itemBuilder: (context, i) {
          final c = _courses[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.school, color: Colors.orangeAccent),
              title: Text(c['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(c['price'] ?? '', style: const TextStyle(color: Colors.greenAccent)),
              trailing: widget.isAdmin ? IconButton(icon: const Icon(Icons.edit), onPressed: () {}) : ElevatedButton(onPressed: () {}, child: const Text('Enroll')),
            ),
          );
        },
      ),
    );
  }
}
