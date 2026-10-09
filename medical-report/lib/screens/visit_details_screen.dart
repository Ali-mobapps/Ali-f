import 'package:flutter/material.dart';
import '../models/visit_model.dart';
import '../theme/app_theme.dart';
import 'add_visit/add_visit_wizard_screen.dart';

class VisitDetailsScreen extends StatelessWidget {
  final MedicalVisitModel visit;

  const VisitDetailsScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Visit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVisitWizardScreen(selectedDoctor: null),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Visit Record'),
                  content: const Text('Are you sure you want to delete this visit record? This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Visit record deleted.')),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                        Text(visit.visitDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(10)),
                          child: Text(visit.syncStatus, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onTertiaryFixed)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(visit.doctorName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    Text(visit.specialty, style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.apartment, size: 14, color: AppColors.outline),
                        const SizedBox(width: 4),
                        Text(visit.hospitalName, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Diagnosis & Symptoms Section
              _buildSectionCard(
                title: 'Diagnosis & Symptoms',
                icon: Icons.health_and_safety,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Diagnosis', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(visit.diagnosis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    const Text('Symptoms', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(visit.symptoms, style: const TextStyle(fontSize: 13, color: AppColors.onSurface)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Prescribed Medicines Section
              _buildSectionCard(
                title: 'Prescribed Medicines (${visit.medicines.length})',
                icon: Icons.medication,
                child: visit.medicines.isEmpty
                    ? const Text('No medicines prescribed for this visit.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))
                    : Column(
                        children: visit.medicines.map((m) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(m.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text(m.dosage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                              Text('${m.frequency} • ${m.duration} • ${m.mealInstruction}', style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        )).toList(),
                      ),
              ),

              const SizedBox(height: 12),

              // Medical Tests Section
              _buildSectionCard(
                title: 'Medical Tests (${visit.labTests.length})',
                icon: Icons.biotech,
                child: visit.labTests.isEmpty
                    ? const Text('No lab tests ordered for this visit.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))
                    : Column(
                        children: visit.labTests.map((t) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.biotech, color: AppColors.primary),
                          title: Text(t.testName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          subtitle: Text(t.labName),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(10)),
                            child: Text(t.resultStatus, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        )).toList(),
                      ),
              ),

              const SizedBox(height: 12),

              // Prescription & Attachments
              _buildSectionCard(
                title: 'Prescription Slip & Attachments',
                icon: Icons.picture_as_pdf,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.description, color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(visit.prescriptionPdfPath ?? 'Rx_Prescription.pdf', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const Text('Digitally Signed • 1.4 MB', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening prescription document...')));
                        },
                        style: ElevatedButton.styleFrom(minimumSize: const Size(60, 36)),
                        child: const Text('View', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),

              if (visit.doctorNotes != null && visit.doctorNotes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildSectionCard(
                  title: 'Doctor Notes & Advice',
                  icon: Icons.note_alt,
                  child: Text(visit.doctorNotes!, style: const TextStyle(fontSize: 13, color: AppColors.onSurface)),
                ),
              ],

              if (visit.followUpDate != null) ...[
                const SizedBox(height: 12),
                _buildSectionCard(
                  title: 'Follow-Up Date',
                  icon: Icons.event,
                  child: Text('Scheduled Follow-up: ${visit.followUpDate}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
