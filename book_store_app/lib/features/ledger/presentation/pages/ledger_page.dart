import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';

class LedgerPage extends StatelessWidget {
  const LedgerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DashboardLayout(
      selectedIndex: 3,
      child: Column(
        children: [
          // Total Outstanding Summary
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL OUTSTANDING MARKET DEBT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rs. 1,425,000',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Export Ledger'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Customer List and Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer List
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Customers', style: theme.textTheme.titleSmall),
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    prefixIcon: const Icon(Icons.search, size: 18),
                                    isDense: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: 5,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final isActive = index == 0;
                              return Container(
                                decoration: BoxDecoration(
                                  color: isActive ? colorScheme.surfaceVariant.withOpacity(0.3) : null,
                                  border: isActive ? Border(left: BorderSide(color: colorScheme.primary, width: 4)) : null,
                                ),
                                child: ListTile(
                                  title: Text('Customer Name $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('(555) 123-456$index'),
                                  trailing: Text(
                                    'Rs. 4,500',
                                    style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Transaction Details
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sarah Jenkins', style: theme.textTheme.headlineMedium),
                                    const Text('Customer since Oct 2023'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Transaction'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Settle Balance'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.receipt_long_outlined),
                                  title: const Text('Book Purchase - REC-2024-1002'),
                                  subtitle: const Text('Oct 24, 2024'),
                                  trailing: const Text('Rs. 1,200', style: TextStyle(fontWeight: FontWeight.bold)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
