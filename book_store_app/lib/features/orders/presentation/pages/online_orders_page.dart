import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';

class OnlineOrdersPage extends StatefulWidget {
  const OnlineOrdersPage({super.key});

  @override
  State<OnlineOrdersPage> createState() => _OnlineOrdersPageState();
}

class _OnlineOrdersPageState extends State<OnlineOrdersPage> {
  final SupabaseHelper _db = SupabaseHelper();
  List<Map<String, dynamic>> _onlineSales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOnlineSales();
  }

  void _loadOnlineSales() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final data = await _db.getSalesWithItems();
    // Filter only 'Online' payment method sales
    final online = data.where((s) => s['payment_method'] == 'Online').toList();
    if (mounted) {
      setState(() {
        _onlineSales = online;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendDirectWhatsApp(String phone, String message) async {
    // Standardizing phone number for WhatsApp URL
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '92${cleanPhone.substring(1)}';
    }
    
    final url = "https://wa.me/$cleanPhone/?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Share.share(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 4,
      title: 'Online Customers',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF0F172A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ONLINE ORDER TRACKING', 
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${_onlineSales.length} Active Orders', 
                  style: GoogleFonts.inter(color: const Color(0xFFA78BFA), fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadOnlineSales(),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _onlineSales.isEmpty 
                  ? const Center(child: Text('No online orders found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _onlineSales.length,
                      itemBuilder: (context, index) {
                        final sale = _onlineSales[index];
                        final date = DateTime.parse(sale['timestamp']);
                        final customer = sale['customers'];
                        final items = sale['sale_items'] as List;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey.shade100),
                          ),
                          child: ExpansionTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFF5F3FF),
                              child: Icon(Icons.public_rounded, color: Color(0xFF7C3AED), size: 20),
                            ),
                            title: Text(customer?['name'] ?? 'Online Customer', 
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(DateFormat('dd MMM, hh:mm a').format(date)),
                            trailing: Text('Rs. ${sale['final_amount']}', 
                              style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF7C3AED))),
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SHIPPING DETAILS', 
                                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(customer?['address'] ?? 'No address provided', 
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 16),
                                    const Text('ORDER ITEMS', 
                                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ...items.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${item['products']['name']} x ${item['quantity']}", 
                                            style: const TextStyle(fontSize: 13)),
                                          Text("Rs. ${item['quantity'] * item['price_at_sale']}",
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              final billText = items.map((i) => 
                                                "${i['products']['name']} x ${i['quantity']} = Rs. ${i['quantity'] * i['price_at_sale']}").join("\n");
                                              final shareText = "*Online Order Confirmed*\n\n$billText\n\n*Grand Total:* Rs. ${sale['final_amount']}\n\nShipping to: ${customer?['address']}\n\nThank you for choosing Local Shop Store!";
                                              
                                              _sendDirectWhatsApp(customer?['phone'] ?? "", shareText);
                                            },
                                            icon: const Icon(Icons.send_rounded, size: 18),
                                            label: const Text('Send Bill (WhatsApp)'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF25D366),
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
