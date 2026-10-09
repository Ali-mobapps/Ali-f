import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/report_model.dart';
import '../models/visit_model.dart';
import '../models/lab_test_model.dart';
import '../providers/report_provider.dart';
import '../providers/visit_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/report_preview_dialog.dart';

class ReportsManagementScreen extends StatefulWidget {
  const ReportsManagementScreen({super.key});

  @override
  State<ReportsManagementScreen> createState() => _ReportsManagementScreenState();
}

class _ReportsManagementScreenState extends State<ReportsManagementScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';

  void _pickAndUploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'dcm'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final reportId = 'r_${DateTime.now().millisecondsSinceEpoch}';
        
        final newReport = MedicalReportModel(
          id: reportId,
          title: file.name,
          category: 'blood',
          doctorName: 'Dr. Ahmed Khan',
          hospitalName: 'City Medical Hospital',
          reportDate: 'Today',
          statusBadge: 'Normal',
          summaryMetrics: 'Uploaded file: ${file.name}',
          filePath: file.path,
          fileType: file.extension?.toUpperCase() ?? 'PDF',
          drivePath: '/Visits/Today/${file.name}',
          fileSizeMb: (file.size / (1024 * 1024)),
        );

        if (mounted) {
          Provider.of<ReportProvider>(context, listen: false).addReport(newReport);
        }

        final linkedVisit = MedicalVisitModel(
          id: 'v_${DateTime.now().millisecondsSinceEpoch}',
          doctorId: 'd1',
          doctorName: 'Dr. Ahmed Khan',
          specialty: 'Specialist Physician',
          hospitalName: 'City Medical Hospital',
          visitDate: 'Today',
          symptoms: 'Uploaded Report Examination',
          diagnosis: 'Lab Test: ${file.name}',
          doctorNotes: 'Uploaded from phone storage.',
          prescriptionPdfPath: file.name,
          labTests: [
            LabTestModel(
              id: 'lt_${DateTime.now().millisecondsSinceEpoch}',
              visitId: '',
              testName: file.name,
              labName: 'External Lab',
              testDate: 'Today',
              resultStatus: 'Normal',
              summary: 'Uploaded document',
            ),
          ],
          syncStatus: 'Completed',
        );

        if (mounted) {
          Provider.of<VisitProvider>(context, listen: false).addVisit(linkedVisit);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${file.name} saved to storage & synced to Medical History!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload error: $e')),
        );
      }
    }
  }

  Future<void> _downloadReport(MedicalReportModel report) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('MEDICAL TEST REPORT', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                        pw.Text('Date: ${report.reportDate}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Report Title: ${report.title}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Text('Ordered By: ${report.doctorName}', style: const pw.TextStyle(fontSize: 12)),
                  pw.Text('Hospital: ${report.hospitalName}', style: const pw.TextStyle(fontSize: 12)),
                  pw.Text('Status: ${report.statusBadge}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
                  pw.Divider(height: 30),
                  pw.Text('Findings & Summary:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                  pw.SizedBox(height: 8),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Text(report.summaryMetrics, style: const pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Verified Clinical Record • My Medical History Vault', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      pw.Text('Drive Path: ${report.drivePath}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final filename = '${report.title.replaceAll(RegExp(r'\s+'), '_')}.pdf';

      if (kIsWeb) {
        if (mounted) {
          ReportPreviewDialog.show(context, report);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PDF Generated successfully! Preview opened.')),
          );
        }
      } else {
        final output = await getApplicationDocumentsDirectory();
        final file = File('${output.path}/$filename');
        await file.writeAsBytes(bytes);

        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('PDF Downloaded Successfully'),
              content: Text('Report saved to phone storage:\n\n${file.path}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Share.shareXFiles([XFile(file.path)], text: 'Medical Report PDF: ${report.title}');
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Open / Share'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  Future<void> _downloadCompleteMasterPdf(List<MedicalReportModel> reports, List<MedicalVisitModel> visits) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('COMPLETE MEDICAL REPORT DOSSIER', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    pw.Text('Date: ${DateTime.now().toString().substring(0, 10)}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Paragraph(text: 'Patient Name: Ali Reza | Email: ali.reza.health@gmail.com', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('All Medical Reports (${reports.length})', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
              pw.SizedBox(height: 6),
              ...reports.map((r) => pw.Bullet(text: '${r.title} (${r.reportDate}) - Status: ${r.statusBadge} | ${r.summaryMetrics}')),
              pw.SizedBox(height: 16),
              pw.Text('Medical Visit History (${visits.length})', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
              pw.SizedBox(height: 6),
              ...visits.map((v) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(8),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Date: ${v.visitDate} | Doctor: ${v.doctorName}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        pw.Text('Diagnosis: ${v.diagnosis}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
                        pw.Text('Medicines: ${v.medicines.map((m) => '${m.name} (${m.dosage})').join(', ')}', style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  )),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      if (kIsWeb) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Master PDF Dossier generated successfully!')),
          );
        }
      } else {
        final output = await getApplicationDocumentsDirectory();
        final file = File('${output.path}/Complete_Medical_Report_Dossier.pdf');
        await file.writeAsBytes(bytes);

        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Master PDF Downloaded'),
              content: Text('Complete medical dossier saved to phone storage:\n\n${file.path}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Share.shareXFiles([XFile(file.path)], text: 'Complete Medical Report Dossier (PDF)');
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Open / Share'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Master PDF export failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final visitProvider = Provider.of<VisitProvider>(context);
    
    final reports = reportProvider.reports.where((r) {
      final matchesCategory = _selectedCategory == 'all' || r.category == _selectedCategory;
      final query = _searchQuery.toLowerCase();
      final matchesQuery = r.title.toLowerCase().contains(query) ||
          r.doctorName.toLowerCase().contains(query) ||
          r.hospitalName.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Medical Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
            tooltip: 'Download Master PDF Report',
            onPressed: () => _downloadCompleteMasterPdf(reportProvider.reports, visitProvider.visits),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search test reports, scans, doctors...',
                  prefixIcon: Icon(Icons.search, color: AppColors.outline),
                ),
              ),

              const SizedBox(height: 12),

              // Stats Strip Grid
              Row(
                children: [
                  _buildStatPill('${reports.length}', 'Total'),
                  const SizedBox(width: 6),
                  _buildStatPill('4', 'Scans'),
                  const SizedBox(width: 6),
                  _buildStatPill('8', 'Lab Tests'),
                  const SizedBox(width: 6),
                  _buildStatPill('18.4 MB', 'Used'),
                ],
              ),

              const SizedBox(height: 16),

              // Primary Upload Bar with Master PDF Download CTA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.note_add, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add Health Record', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('Instant OCR parsing & Drive backup', style: TextStyle(fontSize: 11, color: AppColors.primaryFixedDim)),
                              ],
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _downloadCompleteMasterPdf(reportProvider.reports, visitProvider.visits),
                          icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
                          label: const Text('Master PDF', style: TextStyle(color: Colors.white, fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white70),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickAndUploadDocument,
                            icon: const Icon(Icons.document_scanner, size: 16, color: AppColors.primary),
                            label: const Text('Camera Scanner', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickAndUploadDocument,
                            icon: const Icon(Icons.upload_file, size: 16, color: AppColors.onPrimaryFixed),
                            label: const Text('Upload PDF/JPG', style: TextStyle(color: AppColors.onPrimaryFixed, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryFixed),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Category Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('all', 'All Reports'),
                    _buildCategoryChip('blood', 'Blood Tests'),
                    _buildCategoryChip('xray', 'X-Ray'),
                    _buildCategoryChip('ultrasound', 'Ultrasound'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Reports Feed
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: report.statusBadge == 'Normal' || report.statusBadge == 'Clear'
                                    ? AppColors.tertiaryFixed
                                    : AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                report.statusBadge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: report.statusBadge == 'Normal' || report.statusBadge == 'Clear'
                                      ? AppColors.onTertiaryFixed
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Text(report.reportDate, style: const TextStyle(fontSize: 11, color: AppColors.outline)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title & Doctor
                        Text(report.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                        Text('Ordered by ${report.doctorName} • ${report.hospitalName}', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 10),

                        // Thumbnail & Metrics Preview Card
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      report.fileType == 'DICOM' ? Icons.view_in_ar : Icons.picture_as_pdf,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                    Text(report.fileType, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(report.summaryMetrics, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                    const SizedBox(height: 2),
                                    Text('${report.fileSizeMb} MB • Hi-Res Document Scan', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Google Drive Path Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_to_drive, size: 12, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Drive: ${report.drivePath}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Action Buttons: Preview & Download
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => ReportPreviewDialog.show(context, report),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Preview Report'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(40)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.download, color: AppColors.primary),
                              tooltip: 'Download Report',
                              onPressed: () => _downloadReport(report),
                              style: IconButton.styleFrom(backgroundColor: AppColors.secondaryFixed),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String cat, String label) {
    final bool isSelected = _selectedCategory == cat;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}
