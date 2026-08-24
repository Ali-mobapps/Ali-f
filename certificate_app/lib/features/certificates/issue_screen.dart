import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/certificate_service.dart';
import '../../services/pdf_service.dart';
import '../../services/template_service.dart';
import 'certificate_model.dart';

class IssueCertificateScreen extends StatefulWidget {
  const IssueCertificateScreen({super.key});

  @override
  State<IssueCertificateScreen> createState() => _IssueCertificateScreenState();
}

class _IssueCertificateScreenState extends State<IssueCertificateScreen> {
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _descController = TextEditingController();
  
  DateTime _issueDate = DateTime.now();
  String _selectedStyle = 'Classic'; 
  Uint8List? _customBackgroundBytes;
  
  final _certificateService = CertificateService();
  final _pdfService = PdfService();
  final _templateService = TemplateService();
  final _picker = ImagePicker();
  bool _isIssuing = false;

  Future<void> _pickBackground() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() {
      _customBackgroundBytes = bytes;
      _selectedStyle = 'Custom';
    });
  }

  Future<void> _issueCertificate() async {
    if (_nameController.text.isEmpty || _courseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipient Name and Course Title are required.")),
      );
      return;
    }

    setState(() => _isIssuing = true);

    try {
      final templateConfig = await _templateService.getTemplate('default') ?? {};
      templateConfig['style'] = _selectedStyle;

      final cert = Certificate(
        id: '', 
        recipientName: _nameController.text,
        recipientEmail: _emailController.text,
        courseTitle: _courseController.text,
        description: _descController.text,
        issueDate: _issueDate,
        status: 'Issued',
        templateId: _selectedStyle.toLowerCase(),
      );

      final certId = await _certificateService.issueCertificate(cert);
      
      final pdfData = await _pdfService.generateCertificate(
        Certificate(
          id: certId,
          recipientName: cert.recipientName,
          recipientEmail: cert.recipientEmail,
          courseTitle: cert.courseTitle,
          description: cert.description,
          issueDate: cert.issueDate,
          status: cert.status,
          templateId: cert.templateId,
        ),
        templateConfig: templateConfig,
        customBackground: _customBackgroundBytes,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: CertifyProTheme.success, size: 28),
                SizedBox(width: 12),
                Text("Certificate Issued"),
              ],
            ),
            content: Text("Successfully generated using '$_selectedStyle' template.\n\nCertificate ID: $certId"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Done")),
              ElevatedButton.icon(
                onPressed: () => _pdfService.saveAndPrint(pdfData, "Cert_$certId"),
                icon: const Icon(Icons.print, size: 18),
                label: const Text("Download PDF"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Issuance failed: $e")));
      }
    }

    setState(() => _isIssuing = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      appBar: const CertifyProTopBar(title: 'New Credential'),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Form
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormCard(
                    title: 'Step 1: Choose Template',
                    children: [
                      const Text('Select a preset or upload your own background image:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTemplateThumb('Classic', Icons.grid_goldenratio),
                            _buildTemplateThumb('Modern', Icons.style),
                            _buildTemplateThumb('Minimalist', Icons.minimize),
                            _buildUploadThumb(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormCard(
                    title: 'Step 2: Recipient Info',
                    children: [
                      _buildField('Full Name', 'Enter recipient name', _nameController),
                      const SizedBox(height: 16),
                      _buildField('Course Title', 'e.g. Graphic Design', _courseController),
                      const SizedBox(height: 16),
                      _buildField('Program Description', 'Brief summary...', _descController, maxLines: 2),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormCard(
                    title: 'Step 3: Logistics',
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildDatePicker('Issue Date', _issueDate, (date) => setState(() => _issueDate = date))),
                          const SizedBox(width: 16),
                          Expanded(child: _buildField('Email (Optional)', 'email@example.com', _emailController)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isIssuing ? null : _issueCertificate,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                    child: _isIssuing 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text('GENERATE CERTIFICATE'),
                  ),
                ],
              ),
            ),
          ),
          
          // Right: Preview
          if (isDesktop)
            Expanded(
              flex: 3,
              child: Container(
                color: CertifyProTheme.surfaceContainerLow,
                padding: const EdgeInsets.all(60),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.414,
                    child: _buildLivePreview(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplateThumb(String name, IconData icon) {
    final bool isSelected = _selectedStyle == name;
    return InkWell(
      onTap: () => setState(() {
        _selectedStyle = name;
        _customBackgroundBytes = null;
      }),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? CertifyProTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? CertifyProTheme.primary : CertifyProTheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 24),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadThumb() {
    final bool isSelected = _selectedStyle == 'Custom';
    return InkWell(
      onTap: _pickBackground,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? CertifyProTheme.primary : CertifyProTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? CertifyProTheme.primary : CertifyProTheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(height: 8),
            Text(isSelected ? 'Custom Set' : 'Upload New', style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40)],
      ),
      child: Stack(
        children: [
          // --- Background Layer ---
          if (_customBackgroundBytes != null)
            Positioned.fill(child: Image.memory(_customBackgroundBytes!, fit: BoxFit.cover)),
          
          if (_selectedStyle == 'Classic' && _customBackgroundBytes == null)
            Positioned.fill(child: Container(margin: const EdgeInsets.all(20), decoration: BoxDecoration(border: Border.all(color: CertifyProTheme.accentGold, width: 3))))
          else if (_selectedStyle == 'Modern' && _customBackgroundBytes == null)
            Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 30, color: CertifyProTheme.primary)),

          // --- Text Overlay Layer ---
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Icon(Icons.verified_user, size: 60, color: CertifyProTheme.primary),
                    const SizedBox(height: 16),
                    const Text('CERTIFICATE OF ACHIEVEMENT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    Container(width: 100, height: 1, color: CertifyProTheme.accentGold, margin: const EdgeInsets.symmetric(vertical: 8)),
                    const Text('This is to certify that', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                  ],
                ),
                Text(
                  _nameController.text.isEmpty ? '[RECIPIENT NAME]' : _nameController.text.toUpperCase(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: CertifyProTheme.primary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _courseController.text.isEmpty ? '[COURSE TITLE]' : _courseController.text,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DATE: ${DateFormat('yyyy-MM-dd').format(_issueDate)}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                    const Icon(Icons.workspace_premium, size: 55, color: CertifyProTheme.accentGold),
                    const Text('AUTHORIZED SIGNATURE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: CertifyProTheme.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const Divider(height: 30),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.all(12)),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime value, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: value, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (date != null) onSelect(date);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: CertifyProTheme.outline), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(value), style: const TextStyle(fontSize: 13)),
                const Icon(Icons.calendar_month, size: 16, color: CertifyProTheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
