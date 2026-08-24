import 'package:flutter/material.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../../inventory/models/product_model.dart';
import '../../models/sale_model.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/pdf_generator.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  final SupabaseHelper _db = SupabaseHelper();
  final List<Map<String, dynamic>> _cart = [];
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final data = await _db.getProducts();
    setState(() {
      _allProducts = data.map((e) => Product.fromMap(e)).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      final existing = _cart.firstWhere((item) => item['product'].id == product.id, orElse: () => {});
      if (existing.isNotEmpty) {
        existing['quantity']++;
      } else {
        _cart.add({'product': product, 'quantity': 1});
      }
    });
  }

  double get _total => _cart.fold(0, (sum, item) => sum + (item['product'].salePrice * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DashboardLayout(
      selectedIndex: 1,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.8),
                    itemCount: _allProducts.length,
                    itemBuilder: (context, index) {
                      final product = _allProducts[index];
                      return Card(
                        child: InkWell(
                          onTap: () => _addToCart(product),
                          child: Column(children: [
                            Expanded(child: Icon(product.type == 'book' ? Icons.book : Icons.edit, size: 40)),
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Rs. ${product.salePrice}'),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade300))),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final item = _cart[index];
                      return ListTile(
                        title: Text(item['product'].name),
                        subtitle: Text('${item['quantity']} x ${item['product'].salePrice}'),
                        trailing: Text('Rs. ${item['product'].salePrice * item['quantity']}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _cart.isEmpty ? null : () async {
                      final saleId = const Uuid().v4();
                      final sale = {
                        'id': saleId,
                        'timestamp': DateTime.now().toIso8601String(),
                        'total_amount': _total,
                        'discount': 0.0,
                        'final_amount': _total,
                      };
                      final items = _cart.map((c) => {
                        'id': const Uuid().v4(),
                        'sale_id': saleId,
                        'product_id': c['product'].id,
                        'quantity': c['quantity'],
                        'price_at_sale': c['product'].salePrice
                      }).toList();

                      await _db.createSale(sale, items);
                      await PdfGenerator.generateAndPrintBill(_total, _cart);
                      setState(() => _cart.clear());
                      _loadProducts();
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale Complete!')));
                    },
                    child: Text('Pay Rs. $_total'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
