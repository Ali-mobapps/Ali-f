import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'invoice_input_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<Map<String, dynamic>>> _invoicesFuture;

  @override
  void initState() {
    super.initState();
    _refreshInvoices();
  }

  void _refreshInvoices() {
    setState(() {
      _invoicesFuture = _supabaseService.fetchInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        title: Text('PREMIUM LEDGER', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshInvoices),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _invoicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final invoices = snapshot.data ?? [];
            if (invoices.isEmpty) {
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 80, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  Text('No Invoices Found', style: GoogleFonts.poppins(fontSize: 18, color: Colors.blueGrey)),
                ],
              ));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                final date = DateTime.parse(invoice['date']);
                final items = invoice['invoice_items'] as List;
                final total = items.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF1E3A8A).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.receipt_long, color: Color(0xFF1E3A8A)),
                    ),
                    title: Text(
                      invoice['client_name'] ?? 'Unknown Client',
                      style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('INV-${invoice['invoice_no']} • ${DateFormat('dd MMM yyyy').format(date)}'),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${total.toStringAsFixed(0)}',
                          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, color: const Color(0xFFC41E3A), fontSize: 16),
                        ),
                        const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InvoiceInputScreen())).then((_) => _refreshInvoices());
        },
        backgroundColor: const Color(0xFFF59E0B), // VIP Gold
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('NEW INVOICE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
