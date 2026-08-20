import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<void> generateAndDownloadInvoice(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Poultry', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                      pw.Text('SMART TRADERS', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('POULTRY SMART TRADERS', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                color: PdfColors.blue900,
                child: pw.Text('SALE INVOICE', textAlign: pw.TextAlign.center, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
              ),
              
              // Metadata Grid
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      _gridField('No:', invoice.serialNo),
                      _gridField('Invoice #:', invoice.invoiceNo),
                      _gridField('DC#:', invoice.dcNo),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _gridField('Date:', DateFormat('dd-MM-yyyy').format(invoice.date)),
                      _gridField('Order #:', invoice.orderNo ?? ''),
                      _gridField('DC#:', invoice.dcNo2 ?? ''),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _gridField('Delivered To:', invoice.clientName),
                      _gridField('Invoiced To:', invoice.invoicedTo),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _gridField('Address:', invoice.address),
                    ],
                  ),
                ],
              ),
              
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(2),
                decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5, color: PdfColors.black)),
                child: pw.Text('Dispatch Information:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
              ),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
                columnWidths: {
                  0: const pw.FixedColumnWidth(25),
                  1: const pw.FlexColumnWidth(4),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1.2),
                  6: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue900),
                    children: [
                      _headerCell('S No'),
                      _headerCell('Name of Product'),
                      _headerCell('Packing'),
                      _headerCell('Qty'),
                      _headerCell('Bonus'),
                      _headerCell('Unit Rate'),
                      _headerCell('Amount'),
                    ],
                  ),
                  ...List.generate(8, (index) {
                    if (index < invoice.items.length) {
                      final item = invoice.items[index];
                      return pw.TableRow(
                        children: [
                          _dataCell('${index + 1}'),
                          _dataCell(item.productName, align: pw.TextAlign.left),
                          _dataCell(item.packing),
                          _dataCell(item.qty),
                          _dataCell(item.bonus ?? ''),
                          _dataCell(item.unitRate.toStringAsFixed(0)),
                          _dataCell(item.amount.toStringAsFixed(0)),
                        ],
                      );
                    } else {
                      return pw.TableRow(
                        children: List.generate(7, (_) => pw.Container(height: 18, decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.2, color: PdfColors.black)))),
                      );
                    }
                  }),
                ],
              ),

              // Totals
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Rupees: ${numberToWords(invoice.totalDue.toInt())} Only', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
                      children: [
                        _totalRow('Gross Amount :', invoice.grossAmount),
                        _totalRow('Discount :', invoice.discount),
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.blue900),
                          children: [
                            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Invoice Amount:', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 8))),
                            pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(invoice.totalDue.toStringAsFixed(0), style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.right)),
                          ],
                        ),
                        _totalRow('Total Due :', invoice.totalDue),
                      ],
                    ),
                  ),
                ],
              ),
              
              pw.Spacer(),
              
              // Footer
              pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        children: [
                           pw.Container(
                             width: 60, height: 60,
                             decoration: pw.BoxDecoration(
                               border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
                               shape: pw.BoxShape.circle,
                             ),
                             child: pw.Center(child: pw.Text('SMART\nTRADERS', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black))),
                           ),
                           pw.SizedBox(height: 2),
                           pw.Text('Company Stamp', style: const pw.TextStyle(fontSize: 6, color: PdfColors.black)),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Container(width: 100, decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.black)))),
                          pw.Text('Sales Coordinator', style: const pw.TextStyle(fontSize: 8, color: PdfColors.black)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    height: 10,
                    width: double.infinity,
                    decoration: const pw.BoxDecoration(color: PdfColors.blue900),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    // On Web, this triggers a direct download or opens the print dialog which has a "Save" option.
    await Printing.sharePdf(bytes: bytes, filename: 'Invoice_${invoice.invoiceNo}.pdf');
  }

  pw.Widget _gridField(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Row(
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 7, color: PdfColors.black)),
          pw.SizedBox(width: 4),
          pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
        ],
      ),
    );
  }

  pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(text, style: pw.TextStyle(color: PdfColors.white, fontSize: 7, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _dataCell(String text, {pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.2, color: PdfColors.black)),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black), textAlign: align),
    );
  }

  pw.TableRow _totalRow(String label, double amount) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.black))),
        pw.Padding(padding: const pw.EdgeInsets.all(3), child: pw.Text(amount.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.black), textAlign: pw.TextAlign.right)),
      ],
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
