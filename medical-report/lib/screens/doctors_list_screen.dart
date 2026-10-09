import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../theme/app_theme.dart';
import 'doctor_profile_screen.dart';
import 'add_doctor_dialog.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors.where((d) {
      final query = _searchQuery.toLowerCase();
      return d.name.toLowerCase().contains(query) ||
          d.specialty.toLowerCase().contains(query) ||
          d.hospitalName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Care Team & Doctors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.primary),
            onPressed: () => AddDoctorDialog.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Search Input
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search doctor by name, specialty, hospital...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Doctor List
              Expanded(
                child: doctors.isEmpty
                    ? const Center(
                        child: Text(
                          'No doctors found. Tap + to add a new doctor.',
                          style: TextStyle(color: AppColors.onSurfaceVariant),
                        ),
                      )
                    : ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doc = doctors[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doc)),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        doc.photoUrl ?? '',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const CircleAvatar(
                                          radius: 28,
                                          backgroundColor: AppColors.primaryFixed,
                                          child: Icon(Icons.person, color: AppColors.primary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  doc.name,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.verified, size: 14, color: AppColors.secondary),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${doc.specialty} • ${doc.qualifications}',
                                            style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${doc.hospitalName} • ${doc.hospitalAddress}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddDoctorDialog.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
