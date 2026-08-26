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
    
    final String style = templateConfig?['style'] ?? 'Professional';
    final String heading = templateConfig?['heading'] ?? "CERTIFICATE OF ACHIEVEMENT";
    final String intro = templateConfig?['intro'] ?? "THIS IS TO CERTIFY THAT";
    final String signatory = templateConfig?['signatory'] ?? "AUTHORIZED SIGNATURE";
    final PdfColor primaryColor = PdfColor.fromInt(0xFF1E293B); // Deep Navy
    final PdfColor accentColor = PdfColor.fromInt(0xFFB4975A); // Gold
    
    pw.MemoryImage? logo;
    if (templateConfig?['logoBase64'] != null) {
      logo = pw.MemoryImage(base64Decode(templateConfig!['logoBase64']));
    }
    
    pw.MemoryImage? signature;
    final String? sigBase64 = cert.signatureBase64 ?? templateConfig?['signatureBase64'];
    if (sigBase64 != null) {
      signature = pw.MemoryImage(base64Decode(sigBase64));
    }

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
                // 1. Background
                if (backgroundImage != null)
                  pw.Positioned.fill(child: pw.Image(backgroundImage, fit: pw.BoxFit.cover))
                else
                  pw.Positioned.fill(child: pw.Container(color: PdfColors.white)),

                // 2. Decorative Borders (Only if no custom background)
                if (backgroundImage == null) ...[
                  // Outer Gold Frame
                  pw.Positioned.fill(
                    child: pw.Container(
                      margin: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: accentColor, width: 2),
                      ),
                    ),
                  ),
                  // Inner Navy Frame
                  pw.Positioned.fill(
                    child: pw.Container(
                      margin: const pw.EdgeInsets.all(25),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: primaryColor, width: 8),
                      ),
                    ),
                  ),
                  // Corner Decorations
                  pw.Positioned(left: 20, top: 20, child: pw.Container(width: 60, height: 60, decoration: pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: accentColor, width: 4), top: pw.BorderSide(color: accentColor, width: 4))))),
                  pw.Positioned(right: 20, top: 20, child: pw.Container(width: 60, height: 60, decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: accentColor, width: 4), top: pw.BorderSide(color: accentColor, width: 4))))),
                  pw.Positioned(left: 20, bottom: 20, child: pw.Container(width: 60, height: 60, decoration: pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: accentColor, width: 4), bottom: pw.BorderSide(color: accentColor, width: 4))))),
                  pw.Positioned(right: 20, bottom: 20, child: pw.Container(width: 60, height: 60, decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: accentColor, width: 4), bottom: pw.BorderSide(color: accentColor, width: 4))))),
                ],

                // 3. Content
                pw.Padding(
                  padding: const pw.EdgeInsets.all(80),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Section
                      pw.Column(
                        children: [
                          if (logo != null) 
                            pw.Image(logo, height: 70)
                          else
                            pw.Icon(pw.IconData(0xe8d3), color: accentColor, size: 60), // Verified Badge Placeholder
                          
                          pw.SizedBox(height: 20),
                          pw.Text(
                            heading.toUpperCase(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 32, 
                              fontWeight: pw.FontWeight.bold, 
                              color: primaryColor, 
                              letterSpacing: 3
                            ),
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.symmetric(vertical: 10),
                            height: 2, 
                            width: 200, 
                            color: accentColor
                          ),
                          pw.Text(
                            intro,
                            style: pw.TextStyle(
                              fontSize: 14, 
                              fontWeight: pw.FontWeight.normal,
                              letterSpacing: 1.5,
                              color: PdfColors.grey700
                            ),
                          ),
                        ],
                      ),

                      // Recipient Section
                      pw.Text(
                        cert.recipientName.toUpperCase(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 48, 
                          fontWeight: pw.FontWeight.bold, 
                          color: primaryColor,
                        ),
                      ),

                      // Achievement Section
                      pw.Column(
                        children: [
                          pw.Text(
                            "FOR SUCCESSFUL COMPLETION OF",
                            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600, letterSpacing: 1),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            cert.courseTitle.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 24, 
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor
                            ),
                          ),
                          if (cert.description.isNotEmpty) ...[
                            pw.SizedBox(height: 10),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                              child: pw.Text(
                                cert.description,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Footer Section (Date & Signature)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          // Date
                          pw.Column(
                            children: [
                              pw.Text(
                                cert.issueDate.toString().split(' ')[0],
                                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor),
                              ),
                              pw.Container(width: 120, height: 1, color: PdfColors.grey400, margin: const pw.EdgeInsets.symmetric(vertical: 4)),
                              pw.Text("DATE", style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                            ],
                          ),
                          
                          // Seal/Badge
                          pw.Container(
                            height: 80,
                            width: 80,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              border: pw.Border.all(color: accentColor, width: 2),
                            ),
                            child: pw.Center(
                              child: pw.Text("VALID", style: pw.TextStyle(color: accentColor, fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            ),
                          ),

                          // Signature
                          pw.Column(
                            children: [
                              if (signature != null)
                                pw.Image(signature, height: 50)
                              else
                                pw.SizedBox(height: 50, child: pw.Center(child: pw.Text("SIGN HERE", style: pw.TextStyle(color: PdfColors.grey300, fontSize: 8)))),
                              pw.Container(width: 150, height: 1, color: PdfColors.grey400, margin: const pw.EdgeInsets.symmetric(vertical: 4)),
                              pw.Text(signatory.toUpperCase(), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: primaryColor)),
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
