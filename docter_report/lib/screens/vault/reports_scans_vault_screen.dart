import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/report_model.dart';
import '../../providers/medical_provider.dart';

class ReportsScansVaultScreen extends StatefulWidget {
  const ReportsScansVaultScreen({super.key});

  @override
  State<ReportsScansVaultScreen> createState() =>
      _ReportsScansVaultScreenState();
}

class _ReportsScansVaultScreenState extends State<ReportsScansVaultScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Lab Report',
    'Radiology / Scans',
    'Prescription',
    'Discharge Summary',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicalProvider>(context);
    final allReports = provider.allReports;

    final filteredReports = allReports.where((rep) {
      final matchesCat =
          _selectedCategory == 'All' || rep.category == _selectedCategory;
      final matchesSearch =
          rep.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Column(
      children: [
        // Search & Upload Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search vault, lab tests, scans...',
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.outline),
                        fillColor: AppColors.surfaceLow,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null && result.files.isNotEmpty) {
                        final file = result.files.first;
                        final newReport = ReportModel(
                          id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
                          title: file.name,
                          category: _selectedCategory == 'All'
                              ? 'Lab Report'
                              : _selectedCategory,
                          filePath: file.path ?? file.name,
                          fileType: file.extension ?? 'pdf',
                          fileSize:
                              '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                          dateAdded: DateTime.now(),
                        );
                        await provider.addReport(newReport);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Report Uploaded to Vault!')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedCategory = cat);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerLow,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.outlineVariant),

        // Reports List
        Expanded(
          child: filteredReports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.folder_open_rounded,
                          size: 56, color: AppColors.outline),
                      SizedBox(height: 12),
                      Text(
                        'No documents found in Vault',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredReports.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final rep = filteredReports[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 0.8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x080F172A),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: rep.category == 'Radiology / Scans'
                                  ? AppColors.secondaryFixed
                                  : AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              rep.category == 'Radiology / Scans'
                                  ? Icons.medical_services_outlined
                                  : Icons.picture_as_pdf,
                              color: rep.category == 'Radiology / Scans'
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rep.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        rep.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      rep.fileSize,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.error, size: 20),
                            onPressed: () {
                              provider.deleteReport(rep.id);
                            },
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
}
