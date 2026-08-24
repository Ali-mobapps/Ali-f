import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../models/product_model.dart';
import '../widgets/add_product_dialog.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final SupabaseHelper _db = SupabaseHelper();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _db.getProducts().then((data) => data.map((e) => Product.fromMap(e)).toList());
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
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => showDialog(context: context, builder: (_) => AddProductDialog(type: 'book', onAdded: _loadProducts)),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Book'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => showDialog(context: context, builder: (_) => AddProductDialog(type: 'stationery', onAdded: _loadProducts)),
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text('Add Stationery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final products = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCard(
                      product: product,
                      onUpdate: _loadProducts,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate;
  const _ProductCard({required this.product, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: theme.textTheme.titleSmall),
                    if (product.courseOrCategory != null && product.courseOrCategory!.isNotEmpty)
                      Text(product.courseOrCategory!, style: theme.textTheme.bodySmall),
                  ],
                ),
                _StockCounter(product: product, onUpdate: onUpdate),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(label: 'Location', value: product.rackLocation ?? '-'),
                _InfoItem(label: 'Sale Price', value: 'Rs. ${product.salePrice}', isBold: true),
                _InfoItem(label: 'Cost', value: 'Rs. ${product.costPrice}'),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () async {
                  await SupabaseHelper().deleteProduct(product.id);
                  onUpdate();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StockCounter extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate;
  const _StockCounter({required this.product, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final bool isLow = product.stockQuantity <= product.minStockThreshold;
    return Row(
      children: [
        if (isLow)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
            child: const Text('Low Stock', style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () async {
                  if (product.stockQuantity > 0) {
                    await SupabaseHelper().updateProduct({...product.toMap(), 'stock_quantity': product.stockQuantity - 1});
                    onUpdate();
                  }
              }),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text('${product.stockQuantity}', style: const TextStyle(fontWeight: FontWeight.bold))),
              IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () async {
                  await SupabaseHelper().updateProduct({...product.toMap(), 'stock_quantity': product.stockQuantity + 1});
                  onUpdate();
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _InfoItem({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
