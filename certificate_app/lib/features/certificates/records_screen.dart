import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/certificate_service.dart';
import '../../services/auth_service.dart';
import '../../services/pdf_service.dart';
import '../../services/template_service.dart';
import 'certificate_model.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final _certificateService = CertificateService();
  final _authService = AuthService();
  final _pdfService = PdfService();
  final _templateService = TemplateService();
  
  String _searchQuery = '';
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = _authService.currentUser;
    if (user != null) {
      final role = await _authService.getUserRole(user.uid);
      if (mounted) setState(() => _userRole = role);
    }
  }

  Future<void> _downloadPdf(Certificate cert) async {
    final templateConfig = await _templateService.getTemplate('default');
    final pdfData = await _pdfService.generateCertificate(cert, templateConfig: templateConfig);
    await _pdfService.saveAndPrint(pdfData, "Cert_${cert.recipientName}");
  }

  Future<void> _shareCertificate(Certificate cert) async {
    final templateConfig = await _templateService.getTemplate('default');
    final pdfData = await _pdfService.generateCertificate(cert, templateConfig: templateConfig);
    
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/${cert.id}.pdf').create();
    await file.writeAsBytes(pdfData);
    await Share.shareXFiles([XFile(file.path)], text: 'Certificate for ${cert.recipientName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CertifyProTopBar(title: 'Issuance History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                    decoration: const InputDecoration(
                      hintText: 'Search by Recipient or Certificate ID...',
                      prefixIcon: Icon(Icons.search, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 18), label: const Text('Filters')),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CertifyProTheme.outlineVariant),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: const BoxDecoration(
                      color: CertifyProTheme.primaryContainer,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        _th('RECIPIENT', flex: 3),
                        _th('COURSE / PROGRAM', flex: 3),
                        _th('DATE', flex: 2),
                        _th('STATUS', flex: 1),
                        _th('ACTIONS', flex: 2, align: TextAlign.right),
                      ],
                    ),
                  ),
                  
                  StreamBuilder<List<Certificate>>(
                    stream: _certificateService.getCertificates(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()));
                      }
                      
                      final certs = snapshot.data?.where((c) => 
                        c.recipientName.toLowerCase().contains(_searchQuery) || 
                        c.id.toLowerCase().contains(_searchQuery)
                      ).toList() ?? [];

                      if (certs.isEmpty) {
                        return const Padding(padding: EdgeInsets.all(60), child: Center(child: Text("No records match your search criteria.")));
                      }

                      return Column(
                        children: certs.map((cert) => _RecordRow(
                          cert: cert,
                          isAdmin: _userRole == 'admin',
                          onRevoke: () => _certificateService.revokeCertificate(cert.id),
                          onShare: () => _shareCertificate(cert),
                          onDownload: () => _downloadPdf(cert),
                        )).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _th(String label, {required int flex, TextAlign align = TextAlign.left}) {
    return Expanded(flex: flex, child: Text(label, textAlign: align, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800)));
  }
}

class _RecordRow extends StatelessWidget {
  final Certificate cert;
  final bool isAdmin;
  final VoidCallback onRevoke;
  final VoidCallback onShare;
  final VoidCallback onDownload;

  const _RecordRow({
    required this.cert, 
    required this.isAdmin, 
    required this.onRevoke, 
    required this.onShare,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRevoked = cert.status == 'Revoked';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: CertifyProTheme.outlineVariant))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: CertifyProTheme.primary,
                  child: Text(cert.recipientName.isNotEmpty ? cert.recipientName[0] : '?', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cert.recipientName, style: const TextStyle(fontWeight: FontWeight.w700, color: CertifyProTheme.primary)),
                      Text(cert.id, style: const TextStyle(fontSize: 10, color: CertifyProTheme.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: Text(cert.courseTitle, style: const TextStyle(fontSize: 14))),
          Expanded(flex: 2, child: Text(DateFormat('yyyy-MM-dd').format(cert.issueDate), style: const TextStyle(fontSize: 13))),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: (isRevoked ? CertifyProTheme.error : CertifyProTheme.success).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(cert.status, textAlign: TextAlign.center, style: TextStyle(color: isRevoked ? CertifyProTheme.error : CertifyProTheme.success, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.file_download_outlined, size: 20), onPressed: onDownload, tooltip: 'Download PDF'),
                IconButton(icon: const Icon(Icons.share, size: 20), onPressed: onShare, tooltip: 'Share PDF'),
                if (!isRevoked && isAdmin)
                  IconButton(icon: const Icon(Icons.cancel, size: 20, color: CertifyProTheme.error), onPressed: onRevoke, tooltip: 'Revoke Certificate'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
