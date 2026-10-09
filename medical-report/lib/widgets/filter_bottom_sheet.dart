import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApply;

  const FilterBottomSheet({super.key, required this.onApply});

  static void show(BuildContext context, Function(Map<String, dynamic> filters) onApply) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FilterBottomSheet(onApply: onApply),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedCategory = 'All';
  String _selectedDateRange = 'All Time';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Medical Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),

          // Date Range
          const Text('Date Range', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['All Time', 'Past Month', 'Past 6 Months', 'This Year'].map((range) {
              final isSelected = _selectedDateRange == range;
              return ChoiceChip(
                label: Text(range),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedDateRange = range),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Category Filter
          const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['All', 'Blood Tests', 'X-Ray', 'Ultrasound', 'Prescriptions'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedCategory = cat),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _selectedDateRange = 'All Time';
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply({
                      'category': _selectedCategory,
                      'dateRange': _selectedDateRange,
                    });
                    Navigator.pop(context);
                  },
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
