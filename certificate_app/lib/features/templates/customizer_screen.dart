import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/template_service.dart';

class TemplateCustomizerScreen extends StatefulWidget {
  const TemplateCustomizerScreen({super.key});

  @override
  State<TemplateCustomizerScreen> createState() => _TemplateCustomizerScreenState();
}

class _TemplateCustomizerScreenState extends State<TemplateCustomizerScreen> {
  final _templateService = TemplateService();
  final _picker = ImagePicker();
  
  String _selectedTemplate = 'Classic'; // Classic, Modern, Minimalist
  String _heading = 'Certificate of Achievement';
  String _intro = 'This is to certify that';
  String _signatory = 'Director of Certification';
  
  Uint8List? _logoBytes;
  Uint8List? _signatureBytes;
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    final config = await _templateService.getTemplate('default');
    if (config != null && mounted) {
      setState(() {
        _selectedTemplate = config['style'] ?? 'Classic';
        _heading = config['heading'] ?? _heading;
        _intro = config['intro'] ?? _intro;
        _signatory = config['signatory'] ?? _signatory;
        if (config['logoBase64'] != null) {
          _logoBytes = base64Decode(config['logoBase64']);
        }
        if (config['signatureBase64'] != null) {
          _signatureBytes = base64Decode(config['signatureBase64']);
        }
      });
    }
  }

  Future<void> _saveTemplate() async {
    setState(() => _isSaving = true);
    await _templateService.saveTemplate('default', {
      'style': _selectedTemplate,
      'heading': _heading,
      'intro': _intro,
      'signatory': _signatory,
      'logoBase64': _logoBytes != null ? base64Encode(_logoBytes!) : null,
      'signatureBase64': _signatureBytes != null ? base64Encode(_signatureBytes!) : null,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Institution styles updated!")));
    }
    setState(() => _isSaving = false);
  }

  Future<void> _pickImage(bool isLogo) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (image == null) return;
    setState(() => _isUploading = true);
    final bytes = await image.readAsBytes();
    setState(() {
      if (isLogo) {
        _logoBytes = bytes;
      } else {
        _signatureBytes = bytes;
      }
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      appBar: CertifyProTopBar(
        title: 'Institution Branding',
        actions: [
          ElevatedButton(
            onPressed: _isSaving ? null : _saveTemplate,
            child: _isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                : const Text('Save Changes'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Editor
          Expanded(
            flex: isDesktop ? 2 : 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Select Template Style',
                    children: [
                      Wrap(
                        spacing: 12,
                        children: ['Classic', 'Modern', 'Minimalist'].map((style) {
                          final isSelected = _selectedTemplate == style;
                          return ChoiceChip(
                            label: Text(style),
                            selected: isSelected,
                            onSelected: (v) => setState(() => _selectedTemplate = style),
                            selectedColor: CertifyProTheme.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Upload Assets',
                    children: [
                      _buildUploadBox('Institution Logo', Icons.business, _logoBytes, () => _pickImage(true)),
                      const SizedBox(height: 16),
                      _buildUploadBox('Director Signature', Icons.draw, _signatureBytes, () => _pickImage(false)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Global Content',
                    children: [
                      _buildTextField('Main Heading', _heading, (v) => setState(() => _heading = v)),
                      const SizedBox(height: 16),
                      _buildTextField('Introductory Text', _intro, (v) => setState(() => _intro = v)),
                      const SizedBox(height: 16),
                      _buildTextField('Authorized Title (e.g. Director)', _signatory, (v) => setState(() => _signatory = v)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Preview
          if (isDesktop)
            Expanded(
              flex: 3,
              child: Container(
                color: CertifyProTheme.background,
                padding: const EdgeInsets.all(40),
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

  Widget _buildLivePreview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40)],
      ),
      child: Stack(
        children: [
          // Layout styling based on selected template
          if (_selectedTemplate == 'Classic') ...[
            Positioned.fill(child: Container(margin: const EdgeInsets.all(20), decoration: BoxDecoration(border: Border.all(color: CertifyProTheme.accentGold, width: 4)))),
          ] else if (_selectedTemplate == 'Modern') ...[
             Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 40, color: CertifyProTheme.primary)),
          ],
          
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (_logoBytes != null) Image.memory(_logoBytes!, height: 70) else const Icon(Icons.business, size: 70, color: CertifyProTheme.outline),
                    const SizedBox(height: 20),
                    Text(_heading.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: CertifyProTheme.primary)),
                    Text(_intro, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                  ],
                ),
                const Text('[RECIPIENT NAME]', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                const Text('has successfully completed the curriculum requirements.', textAlign: TextAlign.center),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(children: [Text('[ISSUE DATE]', style: TextStyle(fontSize: 10)), Text('DATE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))]),
                    if (_selectedTemplate != 'Minimalist') const Icon(Icons.workspace_premium, size: 70, color: CertifyProTheme.accentGold),
                    Column(
                      children: [
                        if (_signatureBytes != null) Image.memory(_signatureBytes!, height: 40) else Container(width: 80, height: 1, color: Colors.grey),
                        Text(_signatory.toUpperCase(), style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
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

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildUploadBox(String label, IconData icon, Uint8List? bytes, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isUploading ? null : onTap,
          child: Container(
            height: 100, width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: CertifyProTheme.outline)),
            child: _isUploading 
                ? const Center(child: CircularProgressIndicator())
                : bytes != null 
                    ? Image.memory(bytes, fit: BoxFit.contain) 
                    : Icon(icon, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(initialValue: value, onChanged: onChanged, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
