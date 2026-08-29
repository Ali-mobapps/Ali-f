import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../features/ledger/models/customer_model.dart';

class PdfGenerator {
  static pw.Widget _divider() => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Divider(thickness: 0.5, color: PdfColors.grey400, borderStyle: pw.BorderStyle.dashed),
  );

  static Future<void> generateAndPrintBill({
    required String billId,
    required double subtotal,
    required double discount,
    required double total,
    required List<Map<String, dynamic>> cart,
    Customer? customer,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("LOCAL SHOP STORE", 
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Books & Stationery Specialists", style: const pw.TextStyle(fontSize: 8)),
                  pw.Text("Phone: +92 300 1234567", style: const pw.TextStyle(fontSize: 7)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            _divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Bill #${billId.substring(0, 8)}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                pw.Text(DateFormat('dd-MM-yy HH:mm').format(DateTime.now()), style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Row(children: [
              pw.Text("Customer: ", style: const pw.TextStyle(fontSize: 8)),
              pw.Text(customer?.name ?? 'Walk-in', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            ]),
            _divider(),
            pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text("Item", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
                pw.Expanded(child: pw.Text("Qty", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                pw.Expanded(flex: 2, child: pw.Text("Total", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.SizedBox(height: 2),
            ...cart.map((item) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 1),
              child: pw.Row(
                children: [
                  pw.Expanded(flex: 3, child: pw.Text("${item['product'].name}", style: const pw.TextStyle(fontSize: 8))),
                  pw.Expanded(child: pw.Text("${item['quantity']}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                  pw.Expanded(flex: 2, child: pw.Text("Rs. ${item['product'].salePrice * item['quantity']}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                ],
              ),
            )),
            _divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Subtotal:", style: const pw.TextStyle(fontSize: 8)),
                pw.Text("Rs. ${subtotal.toStringAsFixed(0)}", style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
            if (discount > 0)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Discount:", style: const pw.TextStyle(fontSize: 8)),
                  pw.Text("- Rs. ${discount.toStringAsFixed(0)}", style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            pw.SizedBox(height: 2),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("GRAND TOTAL:", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text("Rs. ${total.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            _divider(),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("Thank you for shopping!", style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
                  pw.Text("Books are uniquely portable magic.", style: const pw.TextStyle(fontSize: 6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> reprintBill(Map<String, dynamic> sale) async {
    final items = sale['sale_items'] as List;
    final customer = sale['customers'];
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("LOCAL SHOP STORE", 
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text("REPRINTED RECEIPT", style: pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            _divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Bill #${sale['id'].toString().substring(0, 8)}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                pw.Text(DateFormat('dd-MM-yy HH:mm').format(DateTime.parse(sale['timestamp'])), style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Row(children: [
              pw.Text("Customer: ", style: const pw.TextStyle(fontSize: 8)),
              pw.Text(customer?['name'] ?? 'Walk-in', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            ]),
            _divider(),
            pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text("Item", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
                pw.Expanded(child: pw.Text("Qty", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                pw.Expanded(flex: 2, child: pw.Text("Total", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
              ],
            ),
            pw.SizedBox(height: 2),
            ...items.map((item) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 1),
              child: pw.Row(
                children: [
                  pw.Expanded(flex: 3, child: pw.Text("${item['products']['name']}", style: const pw.TextStyle(fontSize: 8))),
                  pw.Expanded(child: pw.Text("${item['quantity']}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                  pw.Expanded(flex: 2, child: pw.Text("Rs. ${item['quantity'] * item['price_at_sale']}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                ],
              ),
            )),
            _divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("GRAND TOTAL:", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text("Rs. ${sale['final_amount']}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            _divider(),
            pw.Center(
              child: pw.Text("Thank you for shopping!", style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Future<void> generateSalesReport(String period, List<Map<String, dynamic>> sales) async {
    final pdf = pw.Document();
    double totalRev = 0;
    for (var s in sales) {
      totalRev += (s['final_amount'] as num).toDouble();
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text("Sales Report - $period")),
          pw.Text("Generated on: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}"),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: ['Bill ID', 'Date', 'Customer', 'Method', 'Amount'],
            data: sales.map((s) => [
              s['id'].toString().substring(0, 8),
              DateFormat('dd-MM-yy').format(DateTime.parse(s['timestamp'])),
              s['customers']?['name'] ?? 'Walk-in',
              s['payment_method'],
              'Rs. ${s['final_amount']}'
            ]).toList(),
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("Total Revenue: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Rs. ${totalRev.toStringAsFixed(0)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
