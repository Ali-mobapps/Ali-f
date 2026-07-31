// File path: lib/features/presentation/pages/academy_page.dart (ya services_page.dart)

import 'package:flutter/material.dart';

class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  // Yeh rahi aapki tamaam services ki list
  final List<Map<String, String>> dynetixCourses = const [
    {'title': '3D Modeling', 'category': 'Design & Tech'},
    {'title': 'Legal Drafting and Global Compliance', 'category': 'Legal'},
    {'title': 'Full Stack Development with MERN', 'category': 'Development'},
    {'title': 'Cloud Computing', 'category': 'Tech'},
    {'title': 'Shopify Development and Dropshipping', 'category': 'E-Commerce'},
    {'title': 'Mobile Game and App Development', 'category': 'Development'},
    {'title': 'UI/UX & Webflow', 'category': 'Design'},
    {'title': 'Artificial Intelligence using Python', 'category': 'AI & Data'},
    {'title': 'Startup Strategies and Entrepreneurship', 'category': 'Business'},
    {'title': 'Virtual Assistant', 'category': 'Business'},
    {'title': 'Data Analytics and Business Intelligence', 'category': 'AI & Data'},
    {'title': 'QuickBooks', 'category': 'Finance'},
    {'title': 'SEO (Search Engine Optimization)', 'category': 'Marketing'},
    {'title': 'Graphic Design', 'category': 'Design'},
    {'title': 'Creative Writing', 'category': 'Writing'},
    {'title': 'AutoCAD', 'category': 'Engineering'},
    {'title': 'Digital Literacy', 'category': 'Basic Tech'},
    {'title': 'Digital Marketing', 'category': 'Marketing'},
    {'title': 'E-Commerce Management', 'category': 'E-Commerce'},
    {'title': 'Freelancing', 'category': 'Career'},
    {'title': 'Communication and Soft Skills', 'category': 'Personal Dev'},
    {'title': 'Video Editing, Animation and Vlogging', 'category': 'Media'},
    {'title': 'Affiliate Marketing', 'category': 'Marketing'},
    {'title': 'WordPress', 'category': 'Development'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Dynetix Courses & Services', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D1E33),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dynetixCourses.length,
          itemBuilder: (context, index) {
            final course = dynetixCourses[index];
            return Card(
              color: const Color(0xFF1D1E33),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  course['title']!,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    course['category']!,
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 13),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onTap: () {
                  // Yahan aap kisi detail page par navigate kar sakte hain
                },
              ),
            );
          },
        ),
      ),
    );
  }
}