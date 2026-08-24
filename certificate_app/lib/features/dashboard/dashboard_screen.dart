import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets/top_bar.dart';
import '../../services/certificate_service.dart';
import '../../services/pdf_service.dart';
import '../../services/template_service.dart';
import '../certificates/certificate_model.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onQuickIssue;

  const DashboardScreen({super.key, required this.onQuickIssue});

  Future<void> _viewCertificate(BuildContext context, Certificate cert) async {
    final pdfService = PdfService();
    final templateService = TemplateService();
    final templateConfig = await templateService.getTemplate('default');
    final pdfData = await pdfService.generateCertificate(cert, templateConfig: templateConfig);
    await pdfService.saveAndPrint(pdfData, "Cert_${cert.recipientName}");
  }

  @override
  Widget build(BuildContext context) {
    final certificateService = CertificateService();
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const CertifyProTopBar(title: 'Admin Console'),
      body: StreamBuilder<List<Certificate>>(
        stream: certificateService.getCertificates(),
        builder: (context, snapshot) {
          final certs = snapshot.data ?? [];
          final totalIssued = certs.length;
          final recentCerts = certs.take(5).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isMobile),
                const SizedBox(height: 32),
                
                // --- Responsive Stats Grid ---
                LayoutBuilder(builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 600 ? 2 : 1),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 140,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0: return _StatCard(title: 'TOTAL ISSUED', value: totalIssued.toString(), icon: Icons.workspace_premium, color: CertifyProTheme.primary, trend: '+12%');
                        case 1: return const _StatCard(title: 'VERIFIED', value: '100%', icon: Icons.verified_user_outlined, color: CertifyProTheme.success, trend: 'Secure');
                        case 2: return _StatCard(title: 'REVOKED', value: certs.where((c) => c.status == 'Revoked').length.toString(), icon: Icons.cancel_outlined, color: CertifyProTheme.error, trend: 'Invalid');
                        default: return const _StatCard(title: 'SYS UPTIME', value: '99.9%', icon: Icons.bolt, color: Colors.blue, trend: 'Stable');
                      }
                    },
                  );
                }),
                
                const SizedBox(height: 32),
                
                if (MediaQuery.of(context).size.width > 1000)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildActivityFeed(context, recentCerts)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildActionColumn(context)),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildActivityFeed(context, recentCerts),
                      const SizedBox(height: 24),
                      _buildActionColumn(context),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),
              Text('Manage your digital credentials.', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: onQuickIssue,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Quick Issue'),
          ),
      ],
    );
  }

  Widget _buildActivityFeed(BuildContext context, List<Certificate> recentCerts) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CertifyProTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Issuances', style: Theme.of(context).textTheme.titleLarge),
              TextButton(onPressed: () {}, child: const Text('View Logs')),
            ],
          ),
          const Divider(height: 32),
          if (recentCerts.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No records found")))
          else
            ...recentCerts.map((cert) => _ActivityTile(
              cert: cert, 
              onTap: () => _viewCertificate(context, cert),
            )),
        ],
      ),
    );
  }

  Widget _buildActionColumn(BuildContext context) {
    return Column(
      children: [
        _QuickActionCard(
          onTap: onQuickIssue,
          icon: Icons.add_moderator,
          title: 'Issue New',
          subtitle: 'Single credential',
        ),
        const SizedBox(height: 16),
        _PremiumCard(onUpgrade: () => _showUpgradeDialog(context)),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CertifyPro Enterprise'),
        content: const Text('Unlock bulk issuance, API access, and multi-signatory support.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Upgrade')),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CertifyProTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24)),
          Text(trend, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Certificate cert;
  final VoidCallback onTap;

  const _ActivityTile({required this.cert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isRevoked = cert.status == 'Revoked';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: (isRevoked ? Colors.red : Colors.green).withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(isRevoked ? Icons.close : Icons.check, color: isRevoked ? Colors.red : Colors.green, size: 16),
      ),
      title: Text(cert.recipientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(cert.courseTitle, style: const TextStyle(fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, size: 20, color: CertifyProTheme.primary),
            onPressed: onTap,
            tooltip: 'Download PDF',
          ),
          const Icon(Icons.chevron_right, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;

  const _QuickActionCard({required this.onTap, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: CertifyProTheme.primary, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: CertifyProTheme.accentGold, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final VoidCallback onUpgrade;
  const _PremiumCard({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CertifyProTheme.accentGold.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CertifyProTheme.accentGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: CertifyProTheme.accentGold, size: 24),
          const SizedBox(height: 12),
          const Text('Switch to Pro', style: TextStyle(fontWeight: FontWeight.bold, color: CertifyProTheme.primary)),
          const Text('Unlock multi-signatory & bulk issuance tools.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onUpgrade,
            style: ElevatedButton.styleFrom(backgroundColor: CertifyProTheme.primary, minimumSize: const Size(double.infinity, 40)),
            child: const Text('Upgrade Account', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
