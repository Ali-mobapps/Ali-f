// File path: lib/features/presentation/pages/academy_page.dart
import 'package:flutter/material.dart';

class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  // Academy ke specific training programs aur bootcamps ki list
  final List<Map<String, String>> academyPrograms = const [
    {
      'title': 'Full Stack Web Development Bootcamp',
      'duration': '3 Months',
      'level': 'Beginner to Pro',
    },
    {
      'title': 'Python & Artificial Intelligence Masterclass',
      'duration': '2.5 Months',
      'level': 'Intermediate',
    },
    {
      'title': 'Mobile App Development (Flutter)',
      'duration': '3 Months',
      'level': 'All Levels',
    },
    {
      'title': 'UI/UX Design & Webflow Professional',
      'duration': '2 Months',
      'level': 'Beginner Friendly',
    },
    {
      'title': 'Digital Marketing & E-Commerce Expert',
      'duration': '2 Months',
      'level': 'All Levels',
    },
    {
      'title': 'Data Analytics & Business Intelligence',
      'duration': '2.5 Months',
      'level': 'Intermediate',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // Dark theme matching your app
      appBar: AppBar(
        title: const Text('Dynetix Academy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1D1E33),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Featured Training Programs',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: academyPrograms.length,
                itemBuilder: (context, index) {
                  final program = academyPrograms[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.blueAccent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                program['duration']!,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              const SizedBox(width: 20),
                              const Icon(Icons.bar_chart, color: Colors.greenAccent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                program['level']!,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0052CC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Enrollment action ya detail navigation
                              },
                              child: const Text(
                                'Enroll Now',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
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
}