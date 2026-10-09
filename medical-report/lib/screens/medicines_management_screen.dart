import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visit_provider.dart';
import '../theme/app_theme.dart';

class MedicinesManagementScreen extends StatefulWidget {
  const MedicinesManagementScreen({super.key});

  @override
  State<MedicinesManagementScreen> createState() => _MedicinesManagementScreenState();
}

class _MedicinesManagementScreenState extends State<MedicinesManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    final visits = visitProvider.visits;

    // Aggregate medicines from all visits
    final Map<String, List<Map<String, dynamic>>> medicineHistory = {};

    for (var visit in visits) {
      for (var med in visit.medicines) {
        final key = med.name.trim().toLowerCase();
        if (!medicineHistory.containsKey(key)) {
          medicineHistory[key] = [];
        }
        medicineHistory[key]!.add({
          'medicine': med,
          'visit': visit,
        });
      }
    }

    final keys = medicineHistory.keys.where((k) => k.contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Prescribed Medicines'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search medicines by name...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: keys.isEmpty
                    ? const Center(child: Text('No prescribed medicines found.'))
                    : ListView.builder(
                        itemCount: keys.length,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final historyList = medicineHistory[key]!;
                          final latestItem = historyList.first;
                          final med = latestItem['medicine'];
                          final visit = latestItem['visit'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                _showMedicineHistoryModal(context, med.name, historyList);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiaryFixed,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.medication, color: AppColors.tertiary, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                med.name,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.surfaceContainerHigh,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  'Prescribed ${historyList.length}x',
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Latest Dose: ${med.dosage} (${med.frequency})',
                                            style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Last prescribed: ${visit.visitDate} • ${visit.doctorName}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: AppColors.outline),
                                  ],
                                ),
                              ),
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

  void _showMedicineHistoryModal(BuildContext context, String medName, List<Map<String, dynamic>> history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Usage History: $medName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
            ...history.map((item) {
              final med = item['medicine'];
              final visit = item['visit'];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(visit.visitDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        Text(visit.doctorName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Dose: ${med.dosage} • ${med.frequency} for ${med.duration}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('Meal: ${med.mealInstruction} • Diagnosis: ${visit.diagnosis}', style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
