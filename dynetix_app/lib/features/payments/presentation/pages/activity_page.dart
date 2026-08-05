// File path: lib/features/payments/presentation/pages/activity_page.dart
import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/core/services/database_service.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = AppDatabase.allPaymentsLog;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Activity & Payments Log', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Card(
            color: const Color(0xFF1D1E33),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.payment, color: Colors.greenAccent),
              title: Text(payment['item'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Client: ${payment['client']}', style: const TextStyle(color: Colors.grey)),
              trailing: Text('PKR ${payment['amount']}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}