import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../features/certificates/certificate_model.dart';

class PdfService {
  Future<Uint8List> generateCertificate(
    Certificate cert, {
    Map<String, dynamic>? templateConfig,
    Uint8List? customBackground,
  }) async {
    final pdf = pw.Document();
    
    final String style = templateConfig?['style'] ?? 'Classic';
    final String heading = templateConfig?['heading'] ?? "CERTIFICATE OF ACHIEVEMENT";
    final String intro = templateConfig?['intro'] ?? "This is to certify that";
    final String signatory = templateConfig?['signatory'] ?? "DIRECTOR";
    final PdfColor primaryColor = templateConfig?['primaryColor'] != null 
        ? PdfColor.fromInt(templateConfig!['primaryColor']) 
        : PdfColors.blueGrey900;
    
    pw.MemoryImage? logo;
    if (templateConfig?['logoBase64'] != null) {
      logo = pw.MemoryImage(base64Decode(templateConfig!['logoBase64']));
    }
    
    pw.MemoryImage? signature;
    if (templateConfig?['signatureBase64'] != null) {
      signature = pw.MemoryImage(base64Decode(templateConfig!['signatureBase64']));
    }

    // Load custom background image if provided
    pw.MemoryImage? backgroundImage;
    if (customBackground != null) {
      backgroundImage = pw.MemoryImage(customBackground);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Stack(
              children: [
                // --- 1. Background Image Layer ---
                if (backgroundImage != null)
                  pw.Positioned.fill(child: pw.Image(backgroundImage, fit: pw.BoxFit.cover)),

                // --- 2. Programmatic Border Layer (Only if no custom background) ---
                if (backgroundImage == null) ...[
                  if (style == 'Classic') ...[
                    pw.Positioned.fill(
                      child: pw.Container(
                        margin: const pw.EdgeInsets.all(20),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.amber, width: 6),
                        ),
                      ),
                    ),
                    pw.Positioned.fill(
                      child: pw.Container(
                        margin: const pw.EdgeInsets.all(30),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.amber, width: 1),
                        ),
                      ),
                    ),
                  ] else if (style == 'Modern') ...[
                    pw.Positioned(
                      left: 0, top: 0, bottom: 0,
                      child: pw.Container(width: 50, color: primaryColor),
                    ),
                    pw.Positioned(
                      right: 0, top: 0, bottom: 0,
                      child: pw.Container(width: 10, color: PdfColors.amber),
                    ),
                  ],
                ],

                // --- 3. Dynamic Text Content Overlay ---
                pw.Padding(
                  padding: const pw.EdgeInsets.all(60),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        children: [
                          if (logo != null && backgroundImage == null) 
                            pw.Image(logo, height: 90)
                          else if (backgroundImage == null)
                            pw.SizedBox(height: 90),
                            
                          pw.SizedBox(height: 24),
                          pw.Text(
                            heading.toUpperCase(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 28, 
                              fontWeight: pw.FontWeight.bold, 
                              color: backgroundImage != null ? PdfColors.black : primaryColor, 
                              letterSpacing: 2
                            ),
                          ),
                          pw.Container(width: 150, height: 1.5, color: PdfColors.amber, margin: const pw.EdgeInsets.symmetric(vertical: 12)),
                          pw.Text(intro, style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic)),
                        ],
                      ),
                      pw.Text(
                        cert.recipientName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 42, 
                          fontWeight: pw.FontWeight.bold, 
                          color: backgroundImage != null ? PdfColors.black : primaryColor
                        ),
                      ),
                      pw.Text(
                        "has successfully completed the requirements for",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        cert.courseTitle,
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            children: [
                              pw.Container(width: 120, height: 1, color: PdfColors.grey400),
                              pw.Text("DATE"),
                              pw.Text(cert.issueDate.toString().split(' ')[0], style: const pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.BarcodeWidget(
                                barcode: pw.Barcode.qrCode(),
                                data: cert.id,
                                width: 55,
                                height: 55,
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text("ID: ${cert.id.substring(0,8)}...", style: const pw.TextStyle(fontSize: 5)),
                            ],
                          ),
                          pw.Column(
                            children: [
                              if (signature != null)
                                pw.Image(signature, height: 45)
                              else
                                pw.Container(width: 120, height: 1, color: PdfColors.grey400),
                              pw.Text(signatory.toUpperCase(), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            ],
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
    );

    return pdf.save();
  }

  Future<void> saveAndPrint(Uint8List data, String name) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => data,
      name: name,
    );
  }
}
