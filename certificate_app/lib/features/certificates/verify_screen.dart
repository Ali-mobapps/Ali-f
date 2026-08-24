import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/certificate_service.dart';
import 'certificate_model.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool _isLoading = false;
  Certificate? _verifiedCert;
  final _idController = TextEditingController();
  final _certificateService = CertificateService();

  void _verify() async {
    if (_idController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _verifiedCert = null;
    });

    final cert = await _certificateService.verifyCertificate(_idController.text.trim());
    
    setState(() {
      _isLoading = false;
      _verifiedCert = cert;
    });

    if (cert == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No authentic record found for this ID."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _verifiedCert = null;
      _idController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CertifyProTopBar(title: 'Verification Portal'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _verifiedCert == null ? _buildSearchState() : _buildVerifiedState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchState() {
    return Container(
      key: const ValueKey('search'),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: CertifyProTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CertifyProTheme.outlineVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.fact_check, size: 80, color: CertifyProTheme.primary),
          const SizedBox(height: 24),
          Text('Verify a Certificate', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'Enter the unique certificate ID to confirm its authenticity against our records.',
            textAlign: TextAlign.center,
            style: TextStyle(color: CertifyProTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Certificate ID',
              hintText: 'e.g. 550e8400-e29b...',
            ),
            onSubmitted: (_) => _verify(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _verify,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
            child: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Verify Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedState() {
    final cert = _verifiedCert!;
    final isRevoked = cert.status == 'Revoked';

    return Container(
      key: const ValueKey('verified'),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: CertifyProTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isRevoked ? CertifyProTheme.error : CertifyProTheme.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Verify Another'),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isRevoked ? CertifyProTheme.error.withValues(alpha: 0.1) : const Color(0xFFE8F5E9), 
                  shape: BoxShape.circle
                ),
                child: Icon(
                  isRevoked ? Icons.cancel : Icons.check_circle, 
                  color: isRevoked ? CertifyProTheme.error : const Color(0xFF2E7D32), 
                  size: 48
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRevoked ? 'Certificate Revoked' : 'Certificate Verified', 
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isRevoked ? CertifyProTheme.error : const Color(0xFF2E7D32),
                      )
                    ),
                    Text(
                      isRevoked ? 'This credential is no longer valid.' : 'Authentic record found in system.',
                      style: TextStyle(color: CertifyProTheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CertifyProTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem('Recipient Name', cert.recipientName),
                          const SizedBox(height: 16),
                          _buildInfoItem('Certificate Title', cert.courseTitle),
                          const SizedBox(height: 16),
                          _buildInfoItem('Issue Date', DateFormat('MMMM dd, yyyy').format(cert.issueDate)),
                          const SizedBox(height: 16),
                          _buildInfoItem('Certificate ID', cert.id, isSmall: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: CertifyProTheme.outlineVariant),
                          ),
                          child: QrImageView(
                            data: cert.id,
                            version: QrVersions.auto,
                            size: 120.0,
                            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: CertifyProTheme.primary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Secure Hash", style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.assured_workload, color: CertifyProTheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('CertifyPro Official Ledger', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              if (!isRevoked)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CertifyProTheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isSmall = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value, 
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: isSmall ? 13 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
