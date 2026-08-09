import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('About Dynetix'), backgroundColor: Colors.transparent),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.business_center, size: 100, color: Color(0xFF0052CC)),
            SizedBox(height: 24),
            Text('Dynetix Pro', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              'Dynetix is a comprehensive solution for digital services and academic excellence. We provide high-end character modeling, legal drafting, full-stack development, and much more.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
