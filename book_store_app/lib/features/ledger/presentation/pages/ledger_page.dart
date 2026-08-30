import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../models/customer_model.dart';
import 'customer_details_page.dart';
import 'package:uuid/uuid.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  final SupabaseHelper _db = SupabaseHelper();
  List<Customer> _customers = [];
  bool _isLoading = true;
  double _totalDebt = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final customersData = await _db.getCustomers();
    final customers = customersData.map((e) => Customer.fromMap(e)).toList();
    
    // Sort customers so those with highest debt appear first
    customers.sort((a, b) => b.totalBalance.compareTo(a.totalBalance));
    
    double total = customers.fold(0, (sum, c) => sum + c.totalBalance);

    if (mounted) {
      setState(() {
        _customers = customers;
        _totalDebt = total;
        _isLoading = false;
      });
    }
  }

  Future<double> _getTotalSpent(String customerId) async {
    final ledger = await _db.getCustomerLedgerWithBills(customerId);
    double total = 0;
    for (var entry in ledger) {
      if (entry['type'] == 'credit') {
        total += (entry['amount'] as num).toDouble();
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 3,
      title: 'ledger'.tr,
      child: Column(
        children: [
          // Debt Summary Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                Text(
                  'TOTAL OUTSTANDING DEBT',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs. ${_totalDebt.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Search & Actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find by name or phone...',
                      prefixIcon: Icon(Icons.person_search_rounded, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _showAddCustomerDialog,
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                  label: const Text('New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          // Refresh Indicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadData(),
              child: _isLoading 
                ? const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                : _customers.isEmpty 
                  ? const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400,
                        child: Center(child: Text('No customers found')),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        final customer = _customers[index];
                        return _CustomerDebtCard(
                          customer: customer, 
                          getTotalSpent: _getTotalSpent,
                          onTap: () => Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => CustomerDetailsPage(customer: customer))
                          ).then((_) => _loadData()),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog() {
    final name = TextEditingController();
    final phone = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 12),
            TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (name.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                await _db.insertCustomer({
                  'id': const Uuid().v4(),
                  'name': name.text,
                  'phone': phone.text,
                  'address': '',
                  'total_balance': 0.0,
                });
                _loadData();
                navigator.pop();
              }
            }, 
            child: const Text('Create Profile')
          ),
        ],
      ),
    );
  }
}

class _CustomerDebtCard extends StatelessWidget {
  final Customer customer;
  final Future<double> Function(String) getTotalSpent;
  final VoidCallback onTap;

  const _CustomerDebtCard({
    required this.customer, 
    required this.getTotalSpent, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final balance = customer.totalBalance;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFF1F5F9),
                child: Text(customer.name[0].toUpperCase(), 
                  style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(customer.phone, 
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    FutureBuilder<double>(
                      future: getTotalSpent(customer.id),
                      builder: (context, snapshot) {
                        final spent = snapshot.data ?? 0.0;
                        return Text('Business Volume: Rs. ${spent.toStringAsFixed(0)}', 
                          style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold));
                      }
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('DUE BALANCE', 
                    style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(
                    'Rs. ${balance.toStringAsFixed(0)}', 
                    style: TextStyle(
                      color: balance > 0 ? Colors.red : Colors.green, 
                      fontWeight: FontWeight.w900,
                      fontSize: 18
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
