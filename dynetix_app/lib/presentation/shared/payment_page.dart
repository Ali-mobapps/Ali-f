import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('Payments'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard('JazzCash', AppDatabase.adminJazzCash),
            _buildCard('EasyPaisa', AppDatabase.adminEasyPaisa),
            _buildCard('HBL Bank', AppDatabase.adminBank),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String number) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(number, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.copy, color: Colors.blue),
      ),
    );
  }
}
