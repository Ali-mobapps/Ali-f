import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../models/customer_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class CustomerDetailsPage extends StatefulWidget {
  final Customer customer;
  const CustomerDetailsPage({super.key, required this.customer});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final SupabaseHelper _db = SupabaseHelper();
  List<Map<String, dynamic>> _entries = [];
  double _balance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLedger();
  }

  void _loadLedger() async {
    setState(() => _isLoading = true);
    // Fetch ledger entries with joined sales and products
    final data = await _db.getCustomerLedgerWithBills(widget.customer.id);
    
    // Fetch latest balance from customer profile for accuracy
    final customers = await _db.getCustomers();
    final currentCustomer = customers.firstWhere((c) => c['id'] == widget.customer.id);
    
    setState(() {
      _entries = data;
      _balance = (currentCustomer['total_balance'] as num?)?.toDouble() ?? 0.0;
      _isLoading = false;
    });
  }

  void _addPayment() {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: 'Amount Received (Rs.)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                await _db.insertLedgerEntry({
                  'id': const Uuid().v4(),
                  'customer_id': widget.customer.id,
                  'amount': double.tryParse(amountController.text) ?? 0.0,
                  'type': 'payment',
                  'timestamp': DateTime.now().toIso8601String(),
                });
                _loadLedger();
                navigator.pop();
              }
            },
            child: const Text('Settle Balance'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(widget.customer.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A1931),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            color: const Color(0xFF0A1931),
            child: Column(
              children: [
                Text('OUTSTANDING BALANCE', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Rs. ${_balance.toStringAsFixed(0)}', 
                  style: GoogleFonts.inter(
                    color: _balance > 0 ? Colors.redAccent : Colors.greenAccent,
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addPayment,
                      icon: const Icon(Icons.add_card),
                      label: const Text('Record Payment'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => Share.share("Dear ${widget.customer.name}, your outstanding balance at Local Shop Store is Rs. $_balance. Please settle it at your earliest convenience. Thank you!"),
                      icon: const Icon(Icons.share),
                      label: const Text('Send Reminder'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: _entries.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    final isCredit = entry['type'] == 'credit';
                    final date = DateTime.parse(entry['timestamp']);
                    final sale = entry['sales'];
                    final List items = (sale != null) ? (sale['sale_items'] as List) : [];

                    return Card(
                      child: isCredit && items.isNotEmpty
                        ? ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red[50],
                              child: const Icon(Icons.arrow_upward, color: Colors.red, size: 20),
                            ),
                            title: const Text('Credit Purchase', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(date), style: const TextStyle(fontSize: 12)),
                            trailing: Text('Rs. ${entry['amount']}', 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)
                            ),
                            children: [
                              const Divider(indent: 16, endIndent: 16),
                              ...items.map((item) => ListTile(
                                dense: true,
                                title: Text(item['products']['name']),
                                subtitle: Text('${item['quantity']} x Rs. ${item['price_at_sale']}'),
                                trailing: Text('Rs. ${item['quantity'] * item['price_at_sale']}'),
                              )),
                              const SizedBox(height: 8),
                            ],
                          )
                        : ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isCredit ? Colors.red[50] : Colors.green[50],
                              child: Icon(isCredit ? Icons.arrow_upward : Icons.arrow_downward, 
                                color: isCredit ? Colors.red : Colors.green, size: 20),
                            ),
                            title: Text(isCredit ? 'Credit Purchase' : 'Cash Payment', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(date), style: const TextStyle(fontSize: 12)),
                            trailing: Text('Rs. ${entry['amount']}', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isCredit ? Colors.red : Colors.green
                              )
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
}
