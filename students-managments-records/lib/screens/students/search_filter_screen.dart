import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/student_provider.dart';
import '../../widgets/custom_button.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late String _tempDept;
  late String _tempSem;
  late String _tempSortBy;
  late bool _tempAscending;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<StudentProvider>(context, listen: false);
    _tempDept = provider.selectedDepartment;
    _tempSem = provider.selectedSemester;
    _tempSortBy = provider.sortBy;
    _tempAscending = provider.sortAscending;
  }

  void _applyFilters() {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    provider.setDepartmentFilter(_tempDept);
    provider.setSemesterFilter(_tempSem);
    provider.setSorting(_tempSortBy, _tempAscending);
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _tempDept = 'All';
      _tempSem = 'All';
      _tempSortBy = 'name';
      _tempAscending = true;
    });
    final provider = Provider.of<StudentProvider>(context, listen: false);
    provider.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final depts = ['All', ...AppConstants.departments];
    final sems = ['All', ...AppConstants.semesters];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter Criteria'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Department',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _tempDept,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.domain),
              ),
              items: depts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tempDept = val);
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Filter by Semester',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _tempSem,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.timeline),
              ),
              items: sems
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tempSem = val);
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Sort Records By',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'name', label: Text('Name'), icon: Icon(Icons.sort_by_alpha)),
                ButtonSegment(value: 'roll', label: Text('Roll No'), icon: Icon(Icons.numbers)),
                ButtonSegment(value: 'date', label: Text('Date'), icon: Icon(Icons.calendar_today)),
              ],
              selected: {_tempSortBy},
              onSelectionChanged: (set) {
                setState(() => _tempSortBy = set.first);
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text('Sort Direction: ', style: TextStyle(fontWeight: FontWeight.w600)),
                ChoiceChip(
                  label: const Text('Ascending'),
                  selected: _tempAscending,
                  onSelected: (sel) {
                    if (sel) setState(() => _tempAscending = true);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Descending'),
                  selected: !_tempAscending,
                  onSelected: (sel) {
                    if (sel) setState(() => _tempAscending = false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 36),

            CustomButton(
              text: 'Apply Filters',
              onPressed: _applyFilters,
            ),
          ],
        ),
      ),
    );
  }
}
