import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
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
  String _selectedStyle = 'Professional'; 
  Uint8List? _customBackgroundBytes;
  Uint8List? _signatureBytes;
  
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  final _certificateService = CertificateService();
  final _pdfService = PdfService();
  final _templateService = TemplateService();
  final _picker = ImagePicker();
  bool _isIssuing = false;

  @override
  void dispose() {
    _sigController.dispose();
    super.dispose();
  }

  Future<void> _pickBackground() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() {
      _customBackgroundBytes = bytes;
      _selectedStyle = 'Custom';
    });
  }

  Future<void> _pickSignature() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 400);
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() => _signatureBytes = bytes);
  }

  Future<void> _captureSignature() async {
    if (_sigController.isEmpty) return;
    final bytes = await _sigController.toPngBytes();
    if (bytes != null) {
      setState(() => _signatureBytes = bytes);
      if (mounted) Navigator.pop(context);
    }
  }

  void _showSignaturePad() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Draw Signature"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: CertifyProTheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Signature(
                controller: _sigController,
                height: 200,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => _sigController.clear(), child: const Text("Clear")),
                ElevatedButton(onPressed: _captureSignature, child: const Text("Confirm")),
              ],
            )
          ],
        ),
      ),
    );
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
      
      String? sigBase64;
      if (_signatureBytes != null) {
        sigBase64 = base64Encode(_signatureBytes!);
      }

      final cert = Certificate(
        id: '', 
        recipientName: _nameController.text,
        recipientEmail: _emailController.text,
        courseTitle: _courseController.text,
        description: _descController.text,
        issueDate: _issueDate,
        status: 'Issued',
        templateId: _selectedStyle.toLowerCase(),
        signatureBase64: sigBase64,
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
          signatureBase64: sigBase64,
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
                icon: const Icon(Icons.download, size: 18),
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
      appBar: const CertifyProTopBar(title: 'Create Professional Certificate'),
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
                    title: 'Step 1: Branding & Style',
                    children: [
                      const Text('Select a layout or upload your Canva background:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTemplateThumb('Professional', Icons.workspace_premium),
                            _buildTemplateThumb('Classic', Icons.grid_goldenratio),
                            _buildTemplateThumb('Modern', Icons.style),
                            _buildUploadThumb(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormCard(
                    title: 'Step 2: Recipient Details',
                    children: [
                      _buildField('Full Name', 'Enter recipient name', _nameController),
                      const SizedBox(height: 16),
                      _buildField('Achievement / Course', 'e.g. Data Science Masterclass', _courseController),
                      const SizedBox(height: 16),
                      _buildField('Description (Optional)', 'Detailed accomplishments...', _descController, maxLines: 2),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormCard(
                    title: 'Step 3: Validation & Signature',
                    children: [
                      _buildDatePicker('Issue Date', _issueDate, (date) => setState(() => _issueDate = date)),
                      const SizedBox(height: 20),
                      const Text('Certificate Signature', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (_signatureBytes != null)
                            Container(
                              height: 60,
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: CertifyProTheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.memory(_signatureBytes!, fit: BoxFit.contain),
                            ),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _showSignaturePad,
                                  icon: const Icon(Icons.gesture, size: 16),
                                  label: const Text('Draw'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _pickSignature,
                                  icon: const Icon(Icons.upload, size: 16),
                                  label: const Text('Upload'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isIssuing ? null : _issueCertificate,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: CertifyProTheme.primary,
                    ),
                    child: _isIssuing 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text('GENERATE PROFESSIONAL CERTIFICATE', style: TextStyle(letterSpacing: 1.2)),
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
          // Background Layer
          if (_customBackgroundBytes != null)
            Positioned.fill(child: Image.memory(_customBackgroundBytes!, fit: BoxFit.cover))
          else if (_selectedStyle == 'Professional') ...[
             Positioned.fill(child: Container(margin: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: CertifyProTheme.accentGold, width: 1)))),
             Positioned.fill(child: Container(margin: const EdgeInsets.all(20), decoration: BoxDecoration(border: Border.all(color: CertifyProTheme.primary, width: 6)))),
          ],

          // Content Layer
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Icon(Icons.workspace_premium, size: 60, color: CertifyProTheme.accentGold),
                    const SizedBox(height: 16),
                    Text('CERTIFICATE OF ACHIEVEMENT', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20, letterSpacing: 2)),
                    Container(width: 100, height: 2, color: CertifyProTheme.accentGold, margin: const EdgeInsets.symmetric(vertical: 8)),
                    const Text('THIS IS TO CERTIFY THAT', style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey)),
                  ],
                ),
                Text(
                  _nameController.text.isEmpty ? '[RECIPIENT NAME]' : _nameController.text.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 34, color: CertifyProTheme.primary),
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: [
                    const Text('FOR SUCCESSFUL COMPLETION OF', style: TextStyle(fontSize: 9, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      _courseController.text.isEmpty ? '[ACHIEVEMENT TITLE]' : _courseController.text.toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(DateFormat('yyyy-MM-dd').format(_issueDate), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(width: 80, height: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(vertical: 4)),
                        const Text('DATE', style: TextStyle(fontSize: 8, color: Colors.grey)),
                      ],
                    ),
                    const Icon(Icons.verified, size: 50, color: CertifyProTheme.accentGold),
                    Column(
                      children: [
                        if (_signatureBytes != null)
                          Image.memory(_signatureBytes!, height: 40)
                        else
                          const SizedBox(height: 40, child: Center(child: Text('SIGNATURE', style: TextStyle(fontSize: 8, color: Colors.grey)))),
                        Container(width: 100, height: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(vertical: 4)),
                        const Text('AUTHORIZED BY', style: TextStyle(fontSize: 8, color: Colors.grey)),
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
  }

  Widget _buildFormCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: CertifyProTheme.outlineVariant),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Divider(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CertifyProTheme.primary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime value, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CertifyProTheme.primary)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: value, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (date != null) onSelect(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CertifyProTheme.outline), 
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(value), style: const TextStyle(fontSize: 14)),
                const Icon(Icons.calendar_today, size: 16, color: CertifyProTheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
