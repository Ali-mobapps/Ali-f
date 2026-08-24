import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Manager')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _HomeCard(context, 'POS', Icons.point_of_sale, '/pos', Colors.blue),
          _HomeCard(context, 'Inventory', Icons.inventory, '/inventory', Colors.green),
          _HomeCard(context, 'Ledger (Khata)', Icons.book, '/ledger', Colors.orange),
          _HomeCard(context, 'Insights', Icons.analytics, '/insights', Colors.purple),
        ],
      ),
    );
  }

  Widget _HomeCard(BuildContext context, String title, IconData icon, String route, Color color) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
