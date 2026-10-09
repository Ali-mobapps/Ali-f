import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/medical_provider.dart';
import '../filter/medical_history_filters_sheet.dart';
import '../visit_details/visit_details_record_screen.dart';
import '../wizard/add_medical_visit_wizard_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicalProvider = Provider.of<MedicalProvider>(context);
    final upcoming = medicalProvider.upcomingFollowUp;
    final visits = medicalProvider.visits;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Sync Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Good Morning, Tariq',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('☀️', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Icon(Icons.cloud_sync, size: 16, color: AppColors.tertiary),
                      SizedBox(width: 4),
                      Text(
                        'All records synced with Google Drive',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Prominent Add Visit CTA Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicalVisitWizardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle, color: Colors.white, size: 22),
            label: const Text(
              'Add Medical Visit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar & Filter Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => medicalProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search records, doctors, prescriptions...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.outlineVariant, width: 0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const MedicalHistoryFiltersSheet(),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.outlineVariant, width: 0.8),
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Statistics Grid (2x2)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.1,
            children: [
              _buildStatCard(
                icon: Icons.person_search_rounded,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                count: medicalProvider.doctorsCount.toString(),
                label: 'Doctors',
              ),
              _buildStatCard(
                icon: Icons.calendar_today_rounded,
                iconBg: AppColors.surfaceContainerHighest,
                iconColor: AppColors.secondary,
                count: medicalProvider.visitsCount.toString(),
                label: 'Medical Visits',
              ),
              _buildStatCard(
                icon: Icons.medication_rounded,
                iconBg: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                count: medicalProvider.activeMedsCount.toString(),
                label: 'Active Meds',
              ),
              _buildStatCard(
                icon: Icons.assignment_outlined,
                iconBg: AppColors.secondaryFixed,
                iconColor: AppColors.onSecondaryFixedVariant,
                count: medicalProvider.labReportsCount.toString(),
                label: 'Lab Reports',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Upcoming Follow-Up Banner Card
          if (upcoming != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryFixed, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Upcoming Follow-Up',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'In 3 days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 48,
                          height: 48,
                          color: AppColors.surfaceContainer,
                          child: upcoming.doctorAvatarUrl != null
                              ? Image.network(
                                  upcoming.doctorAvatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                      Icons.person,
                                      color: AppColors.primary),
                                )
                              : const Icon(Icons.person,
                                  color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              upcoming.doctorName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              '${upcoming.doctorSpecialty} • ${upcoming.doctorHospital}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              upcoming.reason,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Recent Medical Visits Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Medical History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  medicalProvider.clearFilters();
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Visits List
          if (medicalProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (visits.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: const [
                    Icon(Icons.folder_off_outlined,
                        size: 48, color: AppColors.outline),
                    SizedBox(height: 10),
                    Text(
                      'No medical records found',
                      style: TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final visit = visits[index];
                return _buildVisitCard(context, visit);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant, width: 0.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(BuildContext context, dynamic visit) {
    final dateStr =
        '${visit.visitDate.day} ${_getMonthName(visit.visitDate.month)} ${visit.visitDate.year}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitDetailsRecordScreen(visit: visit),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant, width: 0.6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: AppColors.surfaceContainer,
                    child: visit.doctorAvatarUrl != null
                        ? Image.network(
                            visit.doctorAvatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                color: AppColors.primary),
                          )
                        : const Icon(Icons.person, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.doctorName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        '${visit.doctorSpecialty} • ${visit.doctorHospital}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.outline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Diagnosis
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                visit.diagnosis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Footer Badges
            Row(
              children: [
                if (visit.prescriptions.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.medication_rounded,
                            size: 12, color: AppColors.tertiary),
                        const SizedBox(width: 4),
                        Text(
                          '${visit.prescriptions.length} Meds',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (visit.reports.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attachment_rounded,
                            size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${visit.reports.length} Reports',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.outline),
              ],
            ),
          ],
        ),
      ),
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
