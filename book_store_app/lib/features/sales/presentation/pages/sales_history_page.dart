import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DashboardLayout(
      selectedIndex: 2,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sales History', style: theme.textTheme.headlineMedium),
                    Text('Track and manage your store receipts', style: theme.textTheme.bodySmall),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Export Report'),
                ),
              ],
            ),
          ),
          // Search and Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by receipt # or customer...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Filter Date'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Sales Table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Receipt #')),
                    DataColumn(label: Text('Date & Time')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Total Amount')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: List.generate(10, (index) {
                    return DataRow(cells: [
                      DataCell(Text('REC-2024-${1000 + index}')),
                      const DataCell(Text('Oct 27, 2024 10:30 AM')),
                      DataCell(Text('Customer $index')),
                      DataCell(Text('Rs. ${500 * (index + 1)}')),
                      DataCell(
                        Chip(
                          label: const Text('Paid'),
                          backgroundColor: Colors.green.shade50,
                          labelStyle: TextStyle(color: Colors.green.shade900),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined),
                          onPressed: () {},
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
