import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../domain/models/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../data/repositories/mock_inventory_repository.dart';
import '../../data/repositories/sqflite_inventory_repository.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final InventoryRepository _repository;
  List<InventoryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _repository = MockInventoryRepository();
    } else {
      _repository = SqfliteInventoryRepository();
    }
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _repository.getInventoryItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DashboardLayout(
      selectedIndex: 0,
      child: Column(
        children: [
          // Header with search and actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search SKU, title, or barcode...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Stationery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.library_add_outlined),
                  label: const Text('Add Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Stock'),
                  selected: true,
                  onSelected: (val) {},
                  backgroundColor: colorScheme.surface,
                  selectedColor: colorScheme.primary,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Books'),
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Stationery'),
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 16, color: colorScheme.error),
                      const SizedBox(width: 4),
                      const Text('Low Stock'),
                    ],
                  ),
                  onSelected: (val) {},
                ),
              ],
            ),
          ),
          // Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Item Details')),
                          DataColumn(label: Text('Location')),
                          DataColumn(label: Text('Pricing')),
                          DataColumn(label: Text('Stock Level')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _items.map((item) {
                          return DataRow(cells: [
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item.author, style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            DataCell(Text(item.location)),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Sell: Rs. ${item.salePrice}'),
                                  Text('Cost: Rs. ${item.costPrice}', style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.isLowStock ? colorScheme.errorContainer : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.stockLevel} units',
                                  style: TextStyle(
                                    color: item.isLowStock ? colorScheme.onErrorContainer : Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () {},
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
