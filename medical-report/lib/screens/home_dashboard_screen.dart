import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/visit_provider.dart';
import '../providers/report_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'doctor_profile_screen.dart';
import 'add_visit/add_visit_wizard_screen.dart';
import 'global_search_screen.dart';
import 'medicines_management_screen.dart';
import 'visit_details_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final visitProvider = Provider.of<VisitProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);

    final doctors = doctorProvider.doctors;
    final visits = visitProvider.visits;
    final reports = reportProvider.reports;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.health_and_safety, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Medical History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                Text(
                  'Home Dashboard',
                  style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalSearchScreen()));
            },
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCoRvpmf7yEz1ANIHrdQnAikBEa_4tZ2B_wtZAYSSehkLN4ZKuGVh-yT5c57kaCHL9Ql3hQuWev72YqdWFIndRCtTFlh2im6jl36JKOEqg9NUT_gL3WZVLAeUwjY5t49O17wgHG5mUx3evzgTF-d-znYsDFZzKCy3DhTjPgJEv9MPYoKhyoJ9ccMADFENzGqrqqHKBfYdcVdcNGZ0GbLha4rFWH2_FE3iUH7RykkejP',
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning, Ali',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.verified_user, size: 14, color: AppColors.tertiary),
                          SizedBox(width: 4),
                          Text('Your health records are up-to-date', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_done, size: 14, color: AppColors.secondary),
                        SizedBox(width: 4),
                        Text('Drive Synced', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalSearchScreen()));
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search doctors, medicines, diagnosis...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          FilterBottomSheet.show(context, (filters) {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.tune, size: 18, color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Record Log CTA Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QUICK RECORD LOG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryFixed)),
                          SizedBox(height: 2),
                          Text('Visited a Clinic Today?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Archive prescriptions, lab vitals & advice.', style: TextStyle(fontSize: 12, color: AppColors.primaryFixedDim)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddVisitWizardScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_circle, size: 18, color: AppColors.primary),
                      label: const Text('+ Add Visit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2x2 Metric Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard(Icons.medical_services, '${doctors.length}', 'Doctors', AppColors.secondaryFixed, AppColors.secondary, () {}),
                  _buildStatCard(Icons.event_available, '${visits.length}', 'Medical Visits', AppColors.primaryFixed, AppColors.primary, () {}),
                  _buildStatCard(Icons.medication, '28', 'Prescriptions', AppColors.tertiaryFixed, AppColors.tertiary, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicinesManagementScreen()));
                  }),
                  _buildStatCard(Icons.assignment_turned_in, '${reports.length}', 'Lab Reports', AppColors.surfaceContainer, AppColors.onSurfaceVariant, () {}),
                ],
              ),

              const SizedBox(height: 16),

              // Upcoming Follow-up Alert Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(left: BorderSide(color: AppColors.secondary, width: 4)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: AppColors.secondary),
                            SizedBox(width: 6),
                            Text('UPCOMING FOLLOW-UP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(6)),
                          child: const Text('In 18 Days', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDyjodeL5OdVcyt4MGyz1IFvEW7pZ64nd3caLa9v8FwM6QdY0bwALfC7DNctQ4pZ-TkkY1C_D7Y6ZIVZsVoJOhCNa_CLxJ5cRBI-eewDRTGz1gucYuAWCr7T5aWziVGJypf-lxtUkkfJS6vMsCvx8bNkESVLdhQPDuopYGl85hGK1qIq3ur4O78S34DWGvCAF5m8mq9TAmqchNW9Dvw98_PJM2wh0m_0-QIRjjI_O3F',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dr. Ahmed Khan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                              Text('Consultant Cardiologist', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w500)),
                              SizedBox(height: 2),
                              Text('City Medical Hospital • 24 Oct 2026', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (doctors.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctors.first)),
                                );
                              }
                            },
                            icon: const Icon(Icons.visibility, size: 16),
                            label: const Text('View Details'),
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Follow-up reminder set for Oct 24, 2026!')),
                            );
                          },
                          icon: const Icon(Icons.notifications_active, size: 16, color: AppColors.primary),
                          label: const Text('Remind Me', style: TextStyle(color: AppColors.primary)),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(110, 40),
                            side: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Care Team Horizontal Scroll
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Care Team', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doc)),
                        );
                      },
                      child: Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(doc.photoUrl ?? 'https://via.placeholder.com/150'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.name,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        doc.specialty,
                                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 28,
                                    decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(6)),
                                    child: const Icon(Icons.call, size: 14, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(6)),
                                    child: const Text('Book', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSecondaryFixed)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Recent Encounters
              const Text('Recent Encounters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => VisitDetailsScreen(visit: visit)),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: visit.syncStatus == 'Completed' ? AppColors.tertiaryFixed : AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, size: 12, color: visit.syncStatus == 'Completed' ? AppColors.onTertiaryFixed : AppColors.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text(
                                      visit.syncStatus,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: visit.syncStatus == 'Completed' ? AppColors.onTertiaryFixed : AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(visit.visitDate, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(visit.doctorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                  const SizedBox(height: 2),
                                  Text(visit.hospitalName, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Diagnosis', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                    Text(visit.diagnosis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            children: [
                              Chip(
                                label: Text('${visit.medicines.length} Medicines', style: const TextStyle(fontSize: 10)),
                                avatar: const Icon(Icons.medication, size: 12, color: AppColors.secondary),
                                visualDensity: VisualDensity.compact,
                              ),
                              Chip(
                                label: Text('${visit.labTests.length} Tests', style: const TextStyle(fontSize: 10)),
                                avatar: const Icon(Icons.biotech, size: 12, color: AppColors.tertiary),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color bg, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
