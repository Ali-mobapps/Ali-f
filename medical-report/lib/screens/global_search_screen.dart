import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/visit_provider.dart';
import '../providers/report_provider.dart';
import '../theme/app_theme.dart';
import 'visit_details_screen.dart';
import 'doctor_profile_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<String> _suggestions = ['Panadol', 'Dr. Ahmed Khan', 'Viral Infection', 'City Medical Hospital', 'CBC Blood Count', 'X-Ray'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final visitProvider = Provider.of<VisitProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);

    final cleanQuery = _query.trim().toLowerCase();

    final matchingDoctors = cleanQuery.isEmpty
        ? []
        : doctorProvider.doctors.where((d) => d.name.toLowerCase().contains(cleanQuery) || d.specialty.toLowerCase().contains(cleanQuery) || d.hospitalName.toLowerCase().contains(cleanQuery)).toList();

    final matchingVisits = cleanQuery.isEmpty
        ? []
        : visitProvider.visits.where((v) =>
            v.diagnosis.toLowerCase().contains(cleanQuery) ||
            v.doctorName.toLowerCase().contains(cleanQuery) ||
            v.symptoms.toLowerCase().contains(cleanQuery) ||
            v.medicines.any((m) => m.name.toLowerCase().contains(cleanQuery)) ||
            v.labTests.any((t) => t.testName.toLowerCase().contains(cleanQuery))).toList();

    final matchingReports = cleanQuery.isEmpty
        ? []
        : reportProvider.reports.where((r) =>
            r.title.toLowerCase().contains(cleanQuery) ||
            r.doctorName.toLowerCase().contains(cleanQuery) ||
            r.category.toLowerCase().contains(cleanQuery)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (val) => setState(() => _query = val),
          decoration: InputDecoration(
            hintText: 'Search doctors, medicines, diagnosis, tests...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_query.isEmpty) ...[
                const Text('Quick Suggestions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestions.map((s) => ActionChip(
                    label: Text(s),
                    onPressed: () {
                      _controller.text = s;
                      setState(() => _query = s);
                    },
                  )).toList(),
                ),
              ] else ...[
                Text('Results for "$_query"', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      if (matchingDoctors.isNotEmpty) ...[
                        const Text('Doctors', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 6),
                        ...matchingDoctors.map((doc) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: AppColors.primary),
                            title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${doc.specialty} • ${doc.hospitalName}'),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doc)));
                            },
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      if (matchingVisits.isNotEmpty) ...[
                        const Text('Medical Visits & Prescriptions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 6),
                        ...matchingVisits.map((v) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.event_available, color: AppColors.secondary),
                            title: Text(v.diagnosis, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${v.visitDate} • ${v.doctorName} (${v.medicines.length} meds)'),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => VisitDetailsScreen(visit: v)));
                            },
                          ),
                        )),
                        const SizedBox(height: 12),
                      ],

                      if (matchingReports.isNotEmpty) ...[
                        const Text('Reports & Scans', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 6),
                        ...matchingReports.map((r) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.description, color: AppColors.tertiary),
                            title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${r.reportDate} • ${r.doctorName}'),
                          ),
                        )),
                      ],

                      if (matchingDoctors.isEmpty && matchingVisits.isEmpty && matchingReports.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('No matching records found.')),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
