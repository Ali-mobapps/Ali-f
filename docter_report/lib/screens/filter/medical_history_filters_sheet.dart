import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/medical_provider.dart';

class MedicalHistoryFiltersSheet extends StatefulWidget {
  const MedicalHistoryFiltersSheet({super.key});

  @override
  State<MedicalHistoryFiltersSheet> createState() =>
      _MedicalHistoryFiltersSheetState();
}

class _MedicalHistoryFiltersSheetState
    extends State<MedicalHistoryFiltersSheet> {
  String _tempCategory = 'All';
  String? _tempDoctorId;

  final List<String> _categories = [
    'All',
    'Cardiologist',
    'Neurologist',
    'General Physician',
    'Pulmonologist',
    'Orthopedic Surgeon',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MedicalProvider>(context, listen: false);
    _tempCategory = provider.selectedCategory;
    _tempDoctorId = provider.selectedDoctorId;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicalProvider>(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Medical History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 16),

          // Medical Category
          const Text(
            'Specialty / Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _tempCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _tempCategory = cat);
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surfaceContainerLow,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Doctor Filter
          const Text(
            'Doctor',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: _tempDoctorId,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All Doctors'),
              ),
              ...provider.doctors.map((doc) {
                return DropdownMenuItem<String?>(
                  value: doc.id,
                  child: Text(doc.name),
                );
              }),
            ],
            onChanged: (val) {
              setState(() => _tempDoctorId = val);
            },
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    provider.clearFilters();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    provider.setCategoryFilter(_tempCategory);
                    provider.setDoctorFilter(_tempDoctorId);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
