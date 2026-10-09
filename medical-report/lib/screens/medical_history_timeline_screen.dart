import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visit_provider.dart';
import '../theme/app_theme.dart';
import 'add_visit/add_visit_wizard_screen.dart';

class MedicalHistoryTimelineScreen extends StatefulWidget {
  const MedicalHistoryTimelineScreen({super.key});

  @override
  State<MedicalHistoryTimelineScreen> createState() => _MedicalHistoryTimelineScreenState();
}

class _MedicalHistoryTimelineScreenState extends State<MedicalHistoryTimelineScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    final visits = visitProvider.visits.where((v) {
      final query = _searchQuery.toLowerCase();
      return v.diagnosis.toLowerCase().contains(query) ||
          v.doctorName.toLowerCase().contains(query) ||
          v.symptoms.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Medical Timeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddVisitWizardScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search timeline by diagnosis or doctor...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: visits.isEmpty
                    ? const Center(child: Text('No medical history records found.'))
                    : ListView.builder(
                        itemCount: visits.length,
                        itemBuilder: (context, index) {
                          final visit = visits[index];
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
                                    Text(visit.visitDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(10)),
                                      child: Text(visit.syncStatus, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onTertiaryFixed)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(visit.diagnosis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                Text('${visit.doctorName} • ${visit.hospitalName}', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                Text('Symptoms: ${visit.symptoms}', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
