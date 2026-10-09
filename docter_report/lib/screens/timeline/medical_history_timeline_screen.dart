import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/medical_provider.dart';
import '../visit_details/visit_details_record_screen.dart';

class MedicalHistoryTimelineScreen extends StatefulWidget {
  const MedicalHistoryTimelineScreen({super.key});

  @override
  State<MedicalHistoryTimelineScreen> createState() =>
      _MedicalHistoryTimelineScreenState();
}

class _MedicalHistoryTimelineScreenState
    extends State<MedicalHistoryTimelineScreen> {
  final List<String> _categories = [
    'All',
    'Cardiologist',
    'Neurologist',
    'General Physician',
    'Pulmonologist'
  ];

  @override
  Widget build(BuildContext context) {
    final medicalProvider = Provider.of<MedicalProvider>(context);
    final visits = medicalProvider.visits;

    return Column(
      children: [
        // Category Filter Chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = medicalProvider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      medicalProvider.setCategoryFilter(cat);
                    },
                    backgroundColor: AppColors.surfaceContainerLow,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.outlineVariant),

        // Timeline Body
        Expanded(
          child: visits.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history_rounded,
                          size: 56, color: AppColors.outline),
                      SizedBox(height: 12),
                      Text(
                        'No medical visits recorded yet',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    final visit = visits[index];
                    final isFirst = index == 0;
                    final isLast = index == visits.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Timeline Spine Column
                          SizedBox(
                            width: 32,
                            child: Column(
                              children: [
                                // Upper line
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isFirst
                                        ? Colors.transparent
                                        : AppColors.outlineVariant,
                                  ),
                                ),
                                // Node Circle
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x33006194),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                // Lower line
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isLast
                                        ? Colors.transparent
                                        : AppColors.outlineVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Visit Card
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VisitDetailsRecordScreen(visit: visit),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppColors.outlineVariant,
                                        width: 0.8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0A0F172A),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${visit.visitDate.day} ${_getMonthName(visit.visitDate.month)} ${visit.visitDate.year}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .surfaceContainerLow,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              visit.consultationType,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        visit.diagnosis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Doctor: ${visit.doctorName} (${visit.doctorSpecialty})',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Symptoms Pill List
                                      if (visit.symptoms.isNotEmpty)
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 4,
                                          children: visit.symptoms.map((sym) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .surfaceContainerHigh
                                                    .withValues(alpha: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                sym,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.onSurface,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
