import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/invoice.dart';
import '../services/supabase_service.dart';
import '../services/pdf_service.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final Invoice invoice;
  const InvoicePreviewScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final pdfService = PdfService();
    final supabaseService = SupabaseService();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SALE INVOICE PREVIEW'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PDF',
            onPressed: () => pdfService.generateAndDownloadInvoice(invoice),
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print Invoice',
            onPressed: () => pdfService.generateAndDownloadInvoice(invoice),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Professional Invoice Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  // Logo/Header Area
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Poultry', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF002D62))),
                            Text('SMART TRADERS', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFC41E3A))),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF002D62),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: const Text('SALE INVOICE', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ),

                  // Metadata Grid
                  _buildGridRow([
                    _gridItem('No:', invoice.serialNo),
                    _gridItem('Invoice #:', invoice.invoiceNo),
                    _gridItem('DC #:', invoice.dcNo),
                  ]),
                  _buildGridRow([
                    _gridItem('Date:', DateFormat('dd-MM-yyyy').format(invoice.date)),
                    _gridItem('Order #:', invoice.orderNo ?? ''),
                    _gridItem('DC #:', invoice.dcNo2 ?? ''),
                  ]),
                  _buildGridRow([
                    _gridItem('Delivered To:', invoice.clientName, flex: 2),
                    _gridItem('Invoiced To:', invoice.invoicedTo),
                  ]),
                  _buildGridRow([
                    _gridItem('Address:', invoice.address),
                  ]),

                  // Table Header
                  Container(
                    color: const Color(0xFF002D62),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: const Row(
                      children: [
                        Expanded(flex: 1, child: HeaderText(text: r'$ No')),
                        Expanded(flex: 4, child: HeaderText(text: 'Product')),
                        Expanded(flex: 2, child: HeaderText(text: 'Pack')),
                        Expanded(flex: 2, child: HeaderText(text: 'Qty')),
                        Expanded(flex: 2, child: HeaderText(text: 'Bonus')),
                        Expanded(flex: 3, child: HeaderText(text: 'Rate')),
                        Expanded(flex: 3, child: HeaderText(text: 'Amount')),
                      ],
                    ),
                  ),

                  // Table Items
                  ...invoice.items.asMap().entries.map((e) => _buildItemRow(e.key + 1, e.value)),

                  // Totals
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Rupees: ${numberToWords(invoice.totalDue.toInt())} Only',
                            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _totalLine('Gross Amount:', invoice.grossAmount),
                              _totalLine('Discount:', invoice.discount),
                              Container(
                                color: const Color(0xFF002D62),
                                padding: const EdgeInsets.all(6),
                                child: _totalLine('Invoice Amt:', invoice.totalDue, color: Colors.white),
                              ),
                              _totalLine('Total Due:', invoice.totalDue, isBold: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await supabaseService.saveInvoice(invoice);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice saved successfully!'), backgroundColor: Colors.green));
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                }
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('CONFIRM & UPLOAD TO DATABASE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC41E3A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGridRow(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 0.5)),
      child: Row(children: children),
    );
  }

  Widget _gridItem(String label, String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 0.5)),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF002D62))),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(int index, InvoiceItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200, width: 0.5)),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('$index', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
          Expanded(flex: 4, child: Text(item.productName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(item.packing, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
          Expanded(flex: 2, child: Text(item.qty, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
          Expanded(flex: 2, child: Text(item.bonus ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
          Expanded(flex: 3, child: Text(item.unitRate.toStringAsFixed(0), textAlign: TextAlign.right, style: const TextStyle(fontSize: 10))),
          Expanded(flex: 3, child: Text(item.amount.toStringAsFixed(0), textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFC41E3A)))),
        ],
      ),
    );
  }

  Widget _totalLine(String label, double amt, {Color color = Colors.black, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(amt.toStringAsFixed(0), style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String numberToWords(int n) {
    if (n == 0) return "Zero";
    var units = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"];
    var tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
    String convert(int n) {
      if (n < 20) return units[n];
      if (n < 100) return tens[n ~/ 10] + (n % 10 != 0 ? " " + units[n % 10] : "");
      if (n < 1000) return units[n ~/ 100] + " Hundred" + (n % 100 != 0 ? " and " + convert(n % 100) : "");
      if (n < 100000) return convert(n ~/ 1000) + " Thousand" + (n % 1000 != 0 ? " " + convert(n % 1000) : "");
      if (n < 10000000) return convert(n ~/ 100000) + " Lac" + (n % 100000 != 0 ? " " + convert(n % 100000) : "");
      return n.toString();
    }
    return convert(n);
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold));
}
