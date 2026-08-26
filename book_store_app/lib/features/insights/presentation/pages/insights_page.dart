import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final SupabaseHelper _db = SupabaseHelper();
  double _revenue = 0;
  double _profit = 0;
  double _stockValue = 0;
  int _txCount = 0;
  List<Map<String, dynamic>> _sales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final salesData = await _db.getSalesWithItems();
    final sValue = await _db.getTotalStockValue();

    double rev = 0;
    double prof = 0;
    for (var sale in salesData) {
      rev += (sale['final_amount'] as num).toDouble();
      final items = sale['sale_items'] as List;
      for (var item in items) {
        final cost = (item['products']['cost_price'] as num?)?.toDouble() ?? 0;
        final price = (item['price_at_sale'] as num?)?.toDouble() ?? 0;
        prof += (price - cost) * (item['quantity'] as int);
      }
    }

    setState(() {
      _sales = salesData;
      _revenue = rev;
      _profit = prof;
      _stockValue = sValue;
      _txCount = salesData.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 4,
      title: 'Business Insights',
      child: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Section
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _KpiCard(title: 'Total Revenue', value: 'Rs. ${_revenue.toStringAsFixed(0)}', icon: Icons.payments_outlined, color: Colors.blue),
                    _KpiCard(title: 'Net Profit', value: 'Rs. ${_profit.toStringAsFixed(0)}', icon: Icons.trending_up, color: Colors.green),
                    _KpiCard(title: 'Stock Value', value: 'Rs. ${_stockValue.toStringAsFixed(0)}', icon: Icons.inventory_2_outlined, color: Colors.amber),
                    _KpiCard(title: 'Transactions', value: '$_txCount', icon: Icons.shopping_cart_checkout, color: Colors.purple),
                  ],
                ),
                const SizedBox(height: 32),

                // Chart & Categories Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _ChartSection(sales: _sales)),
                          const SizedBox(width: 24),
                          Expanded(child: _TopCategoriesSection()),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _ChartSection(sales: _sales),
                          const SizedBox(height: 24),
                          _TopCategoriesSection(),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _exportData,
                    icon: const Icon(Icons.download_for_offline_outlined),
                    label: const Text('Export Sales Register to CSV'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A1931)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _exportData() async {
    List<List<dynamic>> rows = [];
    rows.add(["Bill ID", "Date", "Customer", "Amount", "Discount"]);
    for (var s in _sales) {
      rows.add([s['id'], s['timestamp'], s['customers']?['name'] ?? 'Walk-in', s['final_amount'], s['discount']]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    await Share.share(csv, subject: 'Sales Report');
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final List<Map<String, dynamic>> sales;
  const _ChartSection({required this.sales});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sales Trend (Last 7 Days)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 10),
                        FlSpot(1, 15),
                        FlSpot(2, 8),
                        FlSpot(3, 20),
                        FlSpot(4, 18),
                        FlSpot(5, 25),
                        FlSpot(6, 22),
                      ],
                      isCurved: true,
                      color: const Color(0xFF185ADB),
                      barWidth: 4,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Color(0xFF185ADB).withValues(alpha: 0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Selling Classes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),
            _CategoryRow(label: 'Grade 10 / Matric', count: 42, color: Colors.blue),
            _CategoryRow(label: 'O-Levels', count: 35, color: Colors.amber),
            _CategoryRow(label: 'Stationery Items', count: 28, color: Colors.green),
            _CategoryRow(label: 'Grade 9', count: 20, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CategoryRow({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text('$count sold', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: count / 50,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
