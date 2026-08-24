import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/database_helper.dart';
import 'package:csv/csv.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  double totalRevenue = 0.0;
  double totalProfit = 0.0;
  double stockValue = 0.0;
  List<Map<String, dynamic>> _sales = [];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  void _loadInsights() async {
    final sales = await DatabaseHelper().getSales();
    final value = await DatabaseHelper().getTotalStockValue();

    double rev = 0;
    double prof = 0;
    for (var s in sales) {
      rev += (s['final_amount'] as num).toDouble();
      prof += (s['profit'] as num).toDouble();
    }

    setState(() {
      _sales = sales;
      totalRevenue = rev;
      totalProfit = prof;
      stockValue = value;
    });
  }

  void _exportCSV() {
    List<List<dynamic>> rows = [];
    rows.add(["Sale ID", "Timestamp", "Total Amount", "Profit"]);
    for (var s in _sales) {
      rows.add([s['id'], s['timestamp'], s['final_amount'], s['profit']]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    debugPrint("CSV Data: $csv");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV Data generated in console')));
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _StatCard('Total Sales', 'Rs. ${totalRevenue.toStringAsFixed(2)}'),
                _StatCard('Net Profit', 'Rs. ${totalProfit.toStringAsFixed(2)}'),
                _StatCard('Stock Value', 'Rs. ${stockValue.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _exportCSV,
              icon: const Icon(Icons.download),
              label: const Text('Export Sales to CSV'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard(this.label, this.value);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
