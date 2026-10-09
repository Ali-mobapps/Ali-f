import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/doctor_model.dart';
import '../providers/visit_provider.dart';
import '../theme/app_theme.dart';
import 'add_visit/add_visit_wizard_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final Set<String> _expandedVisitIds = {'v1'};

  void _makePhoneCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final Uri url = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _shareDoctor(DoctorModel doc) {
    Share.share('Doctor Profile: ${doc.name} - ${doc.specialty} (${doc.qualifications}). Phone: ${doc.phone}, Hospital: ${doc.hospitalName}');
  }

  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    final doctorVisits = visitProvider.getVisitsForDoctor(widget.doctor.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareDoctor(widget.doctor),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Identity Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.doctor.photoUrl ?? '',
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.primaryFixed,
                              child: Icon(Icons.person, color: AppColors.primary, size: 36),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 6,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(12)),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_user, size: 10, color: AppColors.onTertiaryFixed),
                                        SizedBox(width: 2),
                                        Text('PMDC Verified', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onTertiaryFixed)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                                    child: Text(widget.doctor.qualifications, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(widget.doctor.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                              Text(widget.doctor.specialty, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.call, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(widget.doctor.phone, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _makePhoneCall(widget.doctor.phone),
                            icon: const Icon(Icons.call, size: 16),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openWhatsApp(widget.doctor.whatsapp ?? widget.doctor.phone),
                            icon: const Icon(Icons.chat, size: 16),
                            label: const Text('WhatsApp'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiaryContainer, foregroundColor: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _shareDoctor(widget.doctor),
                          icon: const Icon(Icons.share, color: AppColors.secondary),
                          style: IconButton.styleFrom(backgroundColor: AppColors.secondaryFixed),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Clinical Summary Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Clinical Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSummaryBox('Total Visits', '${doctorVisits.length}', Icons.event_repeat),
                        const SizedBox(width: 10),
                        _buildSummaryBox('Last Visit', doctorVisits.isNotEmpty ? doctorVisits.first.visitDate : 'None', Icons.calendar_today),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Hospital & Practice Location Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PRIMARY AFFILIATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    const SizedBox(height: 4),
                    Text(widget.doctor.hospitalName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.error),
                        const SizedBox(width: 4),
                        Expanded(child: Text(widget.doctor.hospitalAddress, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Consultation Timeline
              const Text('Consultation Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 10),

              doctorVisits.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No recorded visits with this doctor yet.')))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctorVisits.length,
                      itemBuilder: (context, index) {
                        final visit = doctorVisits[index];
                        final isExpanded = _expandedVisitIds.contains(visit.id);

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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Visit Date: ${visit.visitDate}', style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                                      const SizedBox(height: 2),
                                      Text(visit.diagnosis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                                    onPressed: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedVisitIds.remove(visit.id);
                                        } else {
                                          _expandedVisitIds.add(visit.id);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const Divider(height: 20),
                                Text('Symptoms: ${visit.symptoms}', style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                                if (visit.doctorNotes != null) ...[
                                  const SizedBox(height: 6),
                                  Text('Notes: ${visit.doctorNotes}', style: const TextStyle(fontSize: 13, color: AppColors.onSurface)),
                                ],
                                const SizedBox(height: 10),
                                const Text('Prescribed Medicines:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                const SizedBox(height: 6),
                                ...visit.medicines.map((m) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.medication, size: 14, color: AppColors.secondary),
                                          const SizedBox(width: 6),
                                          Text('${m.name} (${m.dosage}) - ${m.frequency} for ${m.duration}', style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    )),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 24),

              // Add New Visit Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddVisitWizardScreen(selectedDoctor: widget.doctor),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle, color: Colors.white),
                label: Text('Add New Visit with ${widget.doctor.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
