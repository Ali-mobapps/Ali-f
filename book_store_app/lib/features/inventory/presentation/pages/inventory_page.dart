import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../models/product_model.dart';
import '../widgets/add_product_dialog.dart';
import '../../../../core/utils/excel_helper.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final SupabaseHelper _db = SupabaseHelper();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _activeFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => _isLoading = true);
    final data = await _db.getProducts();
    setState(() {
      _allProducts = data.map((e) => Product.fromMap(e)).toList();
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final matchesQuery = p.name.toLowerCase().contains(query) || 
                           (p.courseOrCategory?.toLowerCase().contains(query) ?? false);
        
        bool matchesType = true;
        if (_activeFilter == 'Books') {
          matchesType = p.type == 'book';
        } else if (_activeFilter == 'Stationery') {
          matchesType = p.type == 'stationery';
        } else if (_activeFilter == 'Low Stock') {
          matchesType = p.stockQuantity <= p.minStockThreshold;
        }

        return matchesQuery && matchesType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      selectedIndex: 0,
      title: 'Inventory Dashboard',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search title, class or category...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _AddButton(
                        label: 'Add Book',
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF0F172A),
                        onPressed: () => showDialog(
                          context: context, 
                          builder: (_) => AddProductDialog(type: 'book', onAdded: _loadProducts)
                        ),
                      ),
                      const SizedBox(width: 8),
                      _AddButton(
                        label: 'Stationery',
                        icon: Icons.edit_note_rounded,
                        color: const Color(0xFFD97706),
                        onPressed: () => showDialog(
                          context: context, 
                          builder: (_) => AddProductDialog(type: 'stationery', onAdded: _loadProducts)
                        ),
                      ),
                      const SizedBox(width: 8),
                      _AddButton(
                        label: 'Import',
                        icon: Icons.upload_file_rounded,
                        color: const Color(0xFF10B981),
                        onPressed: () async {
                          final products = await ExcelHelper.pickAndParseExcel();
                          if (products.isNotEmpty) {
                            await _db.bulkInsertProducts(products);
                            _loadProducts();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All Items', 
                        isActive: _activeFilter == 'All', 
                        onTap: () { setState(() => _activeFilter = 'All'); _applyFilters(); }
                      ),
                      _FilterChip(
                        label: 'Books', 
                        isActive: _activeFilter == 'Books', 
                        onTap: () { setState(() => _activeFilter = 'Books'); _applyFilters(); }
                      ),
                      _FilterChip(
                        label: 'Stationery', 
                        isActive: _activeFilter == 'Stationery', 
                        onTap: () { setState(() => _activeFilter = 'Stationery'); _applyFilters(); }
                      ),
                      _FilterChip(
                        label: 'Low Stock Alert', 
                        isActive: _activeFilter == 'Low Stock', 
                        isWarning: true,
                        onTap: () { setState(() => _activeFilter = 'Low Stock'); _applyFilters(); }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Catalog Content
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty 
                ? const Center(child: Text('No products matching your search'))
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisExtent: 180,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) => _ProductCard(
                      product: _filteredProducts[index],
                      onUpdate: _loadProducts,
                    ),
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
    final isLow = product.stockQuantity <= product.minStockThreshold;

    return Card(
      elevation: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.type == 'book' ? const Color(0xFFEFF6FF) : const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.type == 'book' ? Icons.menu_book : Icons.edit_note,
                            size: 12,
                            color: product.type == 'book' ? const Color(0xFF2563EB) : const Color(0xFFD97706),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.type.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: product.type == 'book' ? const Color(0xFF2563EB) : const Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isLow)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(6)),
                        child: const Text('LOW STOCK', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.red)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.courseOrCategory != null && product.courseOrCategory!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      product.courseOrCategory!,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RACK: ${product.rackLocation ?? 'N/A'}', style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          'Rs. ${product.salePrice}',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: theme.primaryColor),
                        ),
                        Text(
                          'Cost: Rs. ${product.costPrice}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    _StockControl(product: product, onUpdate: onUpdate),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_note, size: 20, color: Color(0xFF94A3B8)), 
                  onPressed: () => showDialog(context: context, builder: (_) => AddProductDialog(type: product.type, product: product, onAdded: onUpdate))
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent), 
                  onPressed: () => _confirmDelete(context, product.id, onUpdate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, VoidCallback onUpdate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This will permanently remove this item from inventory. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await SupabaseHelper().deleteProduct(id);
              if (context.mounted) Navigator.pop(context);
              onUpdate();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StockControl extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate;
  const _StockControl({required this.product, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () async {
              if (product.stockQuantity > 0) {
                await SupabaseHelper().updateProduct({...product.toMap(), 'stock_quantity': product.stockQuantity - 1});
                onUpdate();
              }
            },
          ),
          Text(
            '${product.stockQuantity}',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () async {
              await SupabaseHelper().updateProduct({...product.toMap(), 'stock_quantity': product.stockQuantity + 1});
              onUpdate();
            },
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AddButton({required this.label, required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isWarning;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isActive, this.isWarning = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
            ? (isWarning ? Colors.red[100] : const Color(0xFFE0E7FF)) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive 
              ? (isWarning ? Colors.red : const Color(0xFF185ADB)) 
              : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive 
              ? (isWarning ? Colors.red : const Color(0xFF185ADB)) 
              : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
