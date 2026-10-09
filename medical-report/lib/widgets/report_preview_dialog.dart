import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/report_model.dart';
import '../theme/app_theme.dart';

class ReportPreviewDialog extends StatefulWidget {
  final MedicalReportModel report;

  const ReportPreviewDialog({super.key, required this.report});

  static void show(BuildContext context, MedicalReportModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportPreviewDialog(report: report),
    );
  }

  @override
  State<ReportPreviewDialog> createState() => _ReportPreviewDialogState();
}

class _ReportPreviewDialogState extends State<ReportPreviewDialog> {
  double _zoomLevel = 1.0;

  void _downloadReport(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${widget.report.title}... Saved to Downloads/ (${widget.report.drivePath})'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OPEN',
          onPressed: () {},
        ),
      ),
    );
  }

  void _shareReport(BuildContext context) {
    Share.share('Medical Report: ${widget.report.title}\nDoctor: ${widget.report.doctorName}\nHospital: ${widget.report.hospitalName}\nSummary: ${widget.report.summaryMetrics}');
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.reportDate} • ${report.hospitalName} • Status: ${report.statusBadge}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Document Canvas Viewer
          Container(
            height: 260,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Transform.scale(
                      scale: _zoomLevel,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(report.hospitalName.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                    const Text('CLINICAL DIAGNOSTIC REPORT', style: TextStyle(fontSize: 8, color: AppColors.outline)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(4)),
                                  child: Text(report.fileType, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onPrimaryFixed)),
                                ),
                              ],
                            ),
                            const Divider(height: 12),
                            Text('Patient: Ali Reza', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            Text('Ref Doctor: ${report.doctorName}', style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
                            Text('Date: ${report.reportDate}', style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('FINDINGS & VALUES:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  const SizedBox(height: 4),
                                  Text(report.summaryMetrics, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Verified & Stamped ✓', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                                  Text('Digital Signature ID: #8F2A-DIAG', style: TextStyle(fontSize: 7, color: AppColors.outline)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Controls Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Page 1 of 1 • ${(_zoomLevel * 100).toInt()}% Zoom', style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.zoom_in, size: 18),
                          onPressed: () => setState(() => _zoomLevel = (_zoomLevel + 0.1).clamp(0.8, 1.5)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_out, size: 18),
                          onPressed: () => setState(() => _zoomLevel = (_zoomLevel - 0.1).clamp(0.8, 1.5)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.print, size: 18),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sending document to printer...')));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareReport(context),
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Send to Doctor'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _downloadReport(context),
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Save PDF Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
