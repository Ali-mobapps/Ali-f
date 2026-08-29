import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/pdf_generator.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
  double _cashSales = 0;
  double _khataSales = 0;
  int _txCount = 0;
  List<Map<String, dynamic>> _sales = [];
  Map<String, int> _categoryStats = {};
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) _loadData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadData({bool showLoading = true}) async {
    if (showLoading) setState(() => _isLoading = true);
    final salesData = await _db.getSalesWithItems();
    final sValue = await _db.getTotalStockValue();

    double rev = 0;
    double prof = 0;
    double cash = 0;
    double khata = 0;
    Map<String, int> catStats = {};

    for (var sale in salesData) {
      final amount = (sale['final_amount'] as num).toDouble();
      rev += amount;
      
      if (sale['payment_method'] == 'Cash') {
        cash += amount;
      } else {
        khata += amount;
      }

      final items = sale['sale_items'] as List;
      for (var item in items) {
        final cost = (item['products']['cost_price'] as num?)?.toDouble() ?? 0;
        final price = (item['price_at_sale'] as num?)?.toDouble() ?? 0;
        final qty = (item['quantity'] as int);
        prof += (price - cost) * qty;

        final category = item['products']['course_or_category'] ?? 'General';
        catStats[category] = (catStats[category] ?? 0) + qty;
      }
    }

    if (mounted) {
      setState(() {
        _sales = salesData;
        _revenue = rev;
        _profit = prof;
        _cashSales = cash;
        _khataSales = khata;
        _stockValue = sValue;
        _txCount = salesData.length;
        _categoryStats = catStats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 5,
      title: 'Business Insights',
      child: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async => _loadData(showLoading: false),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _KpiCard(title: 'Total Revenue', value: 'Rs. ${_revenue.toStringAsFixed(0)}', icon: Icons.payments_outlined, color: Colors.blue),
                      _KpiCard(title: 'Net Profit', value: 'Rs. ${_profit.toStringAsFixed(0)}', icon: Icons.trending_up, color: Colors.green),
                      _KpiCard(title: 'Cash Sales', value: 'Rs. ${_cashSales.toStringAsFixed(0)}', icon: Icons.money, color: Colors.teal),
                      _KpiCard(title: 'Khata Sales', value: 'Rs. ${_khataSales.toStringAsFixed(0)}', icon: Icons.history_edu, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _KpiCard(title: 'Stock Value', value: 'Rs. ${_stockValue.toStringAsFixed(0)}', icon: Icons.inventory_2_outlined, color: Colors.amber),
                      const SizedBox(width: 12),
                      _KpiCard(title: 'Transactions', value: '$_txCount', icon: Icons.shopping_cart_checkout, color: Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _ChartSection(sales: _sales)),
                            const SizedBox(width: 24),
                            Expanded(child: _TopCategoriesSection(categoryStats: _categoryStats)),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _ChartSection(sales: _sales),
                            const SizedBox(height: 24),
                            _TopCategoriesSection(categoryStats: _categoryStats),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (_sales.isEmpty)
                    const Center(child: Text('No transactions yet', style: TextStyle(color: Colors.grey)))
                  else
                    ..._sales.take(5).map((sale) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: sale['payment_method'] == 'Cash' ? Colors.green[50] : Colors.red[50],
                          child: Icon(Icons.receipt_long, size: 16, color: sale['payment_method'] == 'Cash' ? Colors.green : Colors.red),
                        ),
                        title: Text(sale['customers']?['name'] ?? 'Walk-in Customer', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(DateFormat('hh:mm a, EEEE').format(DateTime.parse(sale['timestamp']))),
                        trailing: Text('Rs. ${sale['final_amount']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => PdfGenerator.generateSalesReport('All Time', _sales),
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text('Print PDF Report'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: _exportData,
                            icon: const Icon(Icons.download_for_offline_outlined),
                            label: const Text('Export CSV'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
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
                      belowBarData: BarAreaData(show: true, color: const Color(0xFF185ADB).withValues(alpha: 0.1)),
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
  final Map<String, int> categoryStats;
  const _TopCategoriesSection({required this.categoryStats});

  @override
  Widget build(BuildContext context) {
    var sorted = categoryStats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    var topList = sorted.take(4).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Selling Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 24),
            if (topList.isEmpty)
              const Center(child: Text('No sales data', style: TextStyle(fontSize: 12, color: Colors.grey))),
            ...topList.map((e) => _CategoryRow(
              label: e.key, 
              count: e.value, 
              color: _getColor(topList.indexOf(e))
            )),
          ],
        ),
      ),
    );
  }

  Color _getColor(int index) {
    List<Color> colors = [Colors.blue, Colors.amber, Colors.green, Colors.purple];
    return colors[index % colors.length];
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
