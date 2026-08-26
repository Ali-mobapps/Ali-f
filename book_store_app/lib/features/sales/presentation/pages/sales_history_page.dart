import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';

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
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Rs. ${sale['final_amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(sale['payment_method'], style: TextStyle(fontSize: 10, color: sale['payment_method'] == 'Cash' ? Colors.green : Colors.red)),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Detailed Bill', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(height: 32),
            // Customer Info
            const Text('CUSTOMER DETAILS', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(customer?['name'] ?? 'Walk-in Customer', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (customer != null) ...[
              Text('Phone: ${customer['phone']}', style: const TextStyle(fontSize: 13)),
              Text('Address: ${customer['address']}', style: const TextStyle(fontSize: 13)),
            ],
            const SizedBox(height: 24),
            // Items List
            const Text('ITEMS SOLD', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['products']['name']),
                    subtitle: Text('${item['quantity']} x Rs. ${item['price_at_sale']}'),
                    trailing: Text('Rs. ${item['quantity'] * item['price_at_sale']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  );
                },
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Mode', style: TextStyle(color: Colors.grey)),
                Text(sale['payment_method'], style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Bill', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Rs. ${sale['final_amount']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(sale['id']),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete Bill', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.done),
                    label: const Text('Done'),
                  ),
                ),
              ],
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
}
