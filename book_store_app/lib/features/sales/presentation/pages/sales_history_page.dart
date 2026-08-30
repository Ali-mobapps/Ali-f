import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../../../core/utils/pdf_generator.dart';
import 'package:share_plus/share_plus.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final SupabaseHelper _db = SupabaseHelper();
  List<Map<String, dynamic>> _sales = [];
  bool _isLoading = true;
  String _activeFilter = 'Daily';

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  void _loadSales() async {
    setState(() => _isLoading = true);
    final data = await _db.getSalesWithItems();
    
    final now = DateTime.now();
    List<Map<String, dynamic>> filtered = data.where((sale) {
      final date = DateTime.parse(sale['timestamp']);
      if (_activeFilter == 'Daily') {
        return date.year == now.year && date.month == now.month && date.day == now.day;
      } else if (_activeFilter == 'Weekly') {
        return now.difference(date).inDays <= 7;
      } else if (_activeFilter == 'Monthly') {
        return date.year == now.year && date.month == now.month;
      }
      return true;
    }).toList();

    setState(() {
      _sales = filtered;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 2,
      title: 'bills'.tr,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Daily', 'Weekly', 'Monthly', 'All Time'].map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: _activeFilter == f,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _activeFilter = f);
                        _loadSales();
                      }
                    },
                  ),
                )).toList(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _sales.isEmpty 
                ? const Center(child: Text('No transactions found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sales.length,
                    itemBuilder: (context, index) {
                      final sale = _sales[index];
                      final date = DateTime.parse(sale['timestamp']);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          onTap: () => _showBillDetail(sale),
                          leading: CircleAvatar(
                            backgroundColor: sale['payment_method'] == 'Cash' ? Colors.green[50] : Colors.red[50],
                            child: Icon(
                              sale['payment_method'] == 'Cash' ? Icons.payments : Icons.book,
                              color: sale['payment_method'] == 'Cash' ? Colors.green : Colors.red,
                              size: 20,
                            ),
                          ),
                          title: Text('Bill #${sale['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(date)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Rs. ${sale['final_amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(sale['payment_method'], style: TextStyle(fontSize: 10, color: sale['payment_method'] == 'Cash' ? Colors.green : Colors.red)),
                                ],
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => _confirmDelete(sale['id']),
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
    );
  }

  void _showBillDetail(Map<String, dynamic> sale) {
    final customer = sale['customers'];
    final items = sale['sale_items'] as List;
    final date = DateTime.parse(sale['timestamp']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transaction Details', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      Text(DateFormat('EEEE, dd MMM yyyy • hh:mm a').format(date), style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sale['payment_method'] == 'Cash' ? Colors.green[50] : (sale['payment_method'] == 'Khata' ? Colors.red[50] : Colors.purple[50]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sale['payment_method'].toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: sale['payment_method'] == 'Cash' ? Colors.green : (sale['payment_method'] == 'Khata' ? Colors.red : Colors.purple)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Header (Internal View)
                        Center(
                          child: Column(
                            children: [
                              Text('LOCAL SHOP STORE', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2)),
                              const SizedBox(height: 4),
                              Text('Bill ID: #${sale['id'].toString().substring(0, 8)}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: DottedLine(color: Color(0xFFE2E8F0)),
                        ),
                        
                        // Customer Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.person_outline, size: 18, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CUSTOMER', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                                Text(customer?['name'] ?? 'Walk-in Customer', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        if (customer != null && customer['phone'] != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 38),
                            child: Text(customer['phone'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        Text('ITEMS', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                        const SizedBox(height: 12),
                        ...items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['products']['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    Text('${item['quantity']} × Rs. ${item['price_at_sale']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text('Rs. ${item['quantity'] * item['price_at_sale']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        )),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: DottedLine(color: Color(0xFFE2E8F0)),
                        ),
                        
                        // Summary
                        _summaryRow('Subtotal', 'Rs. ${sale['total_amount']}'),
                        if (sale['discount'] > 0) 
                          _summaryRow('Discount', '- Rs. ${sale['discount']}', valueColor: Colors.red),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL AMOUNT', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text('Rs. ${sale['final_amount']}', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Actions
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          icon: Icons.share_rounded,
                          label: 'Share Bill',
                          onTap: () {
                            final itemsText = items.map((i) => "• ${i['products']['name']}\n  ${i['quantity']} × Rs. ${i['price_at_sale']} = Rs. ${i['quantity'] * i['price_at_sale']}").join("\n\n");
                            final shareText = "✨ *LOCAL SHOP STORE* ✨\n"
                                "----------------------------\n"
                                "🧾 *Bill #${sale['id'].toString().substring(0, 8)}*\n"
                                "📅 Date: ${DateFormat('dd MMM yyyy').format(date)}\n"
                                "👤 Customer: ${customer?['name'] ?? 'Walk-in'}\n"
                                "----------------------------\n"
                                "$itemsText\n"
                                "----------------------------\n"
                                "💰 *Total Amount: Rs. ${sale['final_amount']}*\n"
                                "💳 Payment: ${sale['payment_method']}\n"
                                "----------------------------\n"
                                "🙏 Thank you for your business!";
                            Share.share(shareText);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionBtn(
                          icon: Icons.print_rounded,
                          label: 'Reprint',
                          isPrimary: true,
                          onTap: () => PdfGenerator.reprintBill(sale),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _confirmDelete(sale['id']),
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    label: const Text('Delete Transaction', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String saleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This will permanently remove the bill and any linked ledger entry. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await _db.deleteSale(saleId);
              navigator.pop(); // Close dialog
              navigator.pop(); // Close bottom sheet
              _loadSales();
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: valueColor)),
        ],
      ),
    );
  }

  Widget _actionBtn({required IconData icon, required String label, required VoidCallback onTap, bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isPrimary ? Colors.white : const Color(0xFF0F172A)),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: isPrimary ? Colors.white : const Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  final Color color;
  const DottedLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(width: dashWidth, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: color)));
          }),
        );
      },
    );
  }
}
