import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/dashboard_layout.dart';
import '../../../../core/database/supabase_helper.dart';
import '../../../inventory/models/product_model.dart';
import '../../../ledger/models/customer_model.dart';
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
  List<Product> _filteredProducts = [];
  List<Customer> _customers = [];
  Customer? _selectedCustomer;
  
  final TextEditingController _searchController = TextEditingController();

  double _discount = 0.0;
  double _received = 0.0;
  String _paymentMethod = 'Cash'; // 'Cash' or 'Khata'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final productsData = await _db.getProducts();
    final customersData = await _db.getCustomers();
    if (mounted) {
      setState(() {
        _allProducts = productsData.map((e) => Product.fromMap(e)).toList();
        _filteredProducts = _allProducts;
        _customers = customersData.map((e) => Customer.fromMap(e)).toList();
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item['product'].id == product.id);
      if (index != -1) {
        if (_cart[index]['quantity'] < product.stockQuantity) {
          _cart[index]['quantity']++;
        }
      } else {
        if (product.stockQuantity > 0) {
          _cart.add({'product': product, 'quantity': 1});
        }
      }
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cart[index]['quantity'] + delta;
      if (newQty > 0 && newQty <= _cart[index]['product'].stockQuantity) {
        _cart[index]['quantity'] = newQty;
      } else if (newQty == 0) {
        _cart.removeAt(index);
      }
    });
  }

  double get _subtotal => _cart.fold(0, (sum, item) => sum + (item['product'].salePrice * item['quantity']));
  double get _total => _subtotal - _discount;
  double get _change => _received > _total ? _received - _total : 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 800;

    return DashboardLayout(
      selectedIndex: 1,
      title: 'pos'.tr,
      actions: [
        if (isMobile)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCartBottomSheet,
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('${_cart.length}', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
      ],
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: _filterProducts,
                        decoration: InputDecoration(
                          hintText: 'Search items by name...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFF1F5F9),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addNonCatalogItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Custom Item'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFEB139)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width > 1200 ? 5 : (size.width > 800 ? 3 : 2),
                      childAspectRatio: 0.75, // Adjusted for more vertical space
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final bool isOutOfStock = product.stockQuantity <= 0;
                      return _CatalogItemCard(
                        product: product,
                        isOutOfStock: isOutOfStock,
                        onTap: () => _addToCart(product),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Container(
              width: size.width > 1100 ? 400 : 320,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: _CartPanel(
                cart: _cart,
                customers: _customers,
                selectedCustomer: _selectedCustomer,
                onCustomerChanged: (val) => setState(() => _selectedCustomer = val),
                onUpdateQuantity: _updateQuantity,
                paymentMethod: _paymentMethod,
                onPaymentMethodChanged: (val) => setState(() => _paymentMethod = val),
                subtotal: _subtotal,
                discount: _discount,
                total: _total,
                received: _received,
                change: _change,
                onDiscountChanged: (val) => setState(() => _discount = val),
                onReceivedChanged: (val) => setState(() => _received = val),
                onCheckout: _checkout,
                onShare: _shareReceipt,
                onClear: () => setState(() => _cart.clear()),
              ),
            ),
        ],
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => _CartPanel(
            cart: _cart,
            customers: _customers,
            selectedCustomer: _selectedCustomer,
            onCustomerChanged: (val) {
              setState(() => _selectedCustomer = val);
              setModalState(() {});
            },
            onUpdateQuantity: (idx, delta) {
              _updateQuantity(idx, delta);
              setModalState(() {});
            },
            paymentMethod: _paymentMethod,
            onPaymentMethodChanged: (val) {
              setState(() => _paymentMethod = val);
              setModalState(() {});
            },
            subtotal: _subtotal,
            discount: _discount,
            total: _total,
            received: _received,
            change: _change,
            onDiscountChanged: (val) {
              setState(() => _discount = val);
              setModalState(() {});
            },
            onReceivedChanged: (val) {
              setState(() => _received = val);
              setModalState(() {});
            },
            onCheckout: () {
              Navigator.pop(context);
              _checkout();
            },
            onShare: _shareReceipt,
            onClear: () {
              setState(() => _cart.clear());
              setModalState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _addNonCatalogItem() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                final dummyProduct = Product(
                  id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  type: 'stationery',
                  salePrice: double.tryParse(priceController.text) ?? 0.0,
                  costPrice: 0.0,
                  stockQuantity: 9999,
                );
                _addToCart(dummyProduct);
                Navigator.pop(context);
              }
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  void _checkout() async {
    if (_cart.isEmpty) return;

    if (_paymentMethod == 'Khata' && _selectedCustomer == null) {
      _showNewCustomerDialog();
      return;
    }
    
    _processCheckout();
  }

  void _showNewCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer Details (Khata)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Customer Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final customerId = const Uuid().v4();
                final customerData = {
                  'id': customerId,
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'address': addressController.text,
                  'total_balance': 0.0, // Initial running balance
                };
                final savedCustomer = await _db.insertCustomer(customerData);
                setState(() {
                   _selectedCustomer = Customer.fromMap(savedCustomer);
                   _customers.add(_selectedCustomer!);
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  _processCheckout();
                }
              }
            },
            child: const Text('Save & Checkout'),
          ),
        ],
      ),
    );
  }

  void _processCheckout() async {
    final saleId = const Uuid().v4();
    final sale = {
      'id': saleId,
      'customer_id': _selectedCustomer?.id,
      'timestamp': DateTime.now().toIso8601String(),
      'total_amount': _subtotal,
      'discount': _discount,
      'final_amount': _total,
      'payment_method': _paymentMethod,
    };
    final items = _cart.map((c) => {
      'id': const Uuid().v4(),
      'sale_id': saleId,
      'product_id': c['product'].id.startsWith('temp-') ? null : c['product'].id,
      'quantity': c['quantity'],
      'price_at_sale': c['product'].salePrice
    }).toList();

    await _db.createSale(sale, items);

    // Ledger Logic
    if (_paymentMethod == 'Khata' && _selectedCustomer != null) {
      await _db.insertLedgerEntry({
        'id': const Uuid().v4(),
        'customer_id': _selectedCustomer!.id,
        'amount': _total,
        'type': 'credit',
        'timestamp': DateTime.now().toIso8601String(),
        'sale_id': saleId,
      });
      
      if (_received > 0) {
        await _db.insertLedgerEntry({
          'id': const Uuid().v4(),
          'customer_id': _selectedCustomer!.id,
          'amount': _received > _total ? _total : _received,
          'type': 'payment',
          'timestamp': DateTime.now().toIso8601String(),
          'sale_id': saleId,
        });
      }
    }

    if (!mounted) return;
    await PdfGenerator.generateAndPrintBill(_total, _cart);
    
    if (!mounted) return;
    setState(() {
      _cart.clear();
      _discount = 0;
      _received = 0;
      _selectedCustomer = null;
      _paymentMethod = 'Cash';
    });
    _loadData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Complete & Receipt Printed!'))
    );
  }

  void _shareReceipt() async {
    if (_cart.isEmpty) return;
    final billText = _cart.map((i) => "${i['product'].name} x ${i['quantity']} = Rs. ${i['product'].salePrice * i['quantity']}").join("\n");
    final shareText = "*Local Shop Store - Receipt*\n\n$billText\n\n*Total:* Rs. $_total\n\nThank you for shopping!";
    await Share.share(shareText);
  }
}

class _CartPanel extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final Function(Customer?) onCustomerChanged;
  final Function(int, int) onUpdateQuantity;
  final String paymentMethod;
  final Function(String) onPaymentMethodChanged;
  final double subtotal;
  final double discount;
  final double total;
  final double received;
  final double change;
  final Function(double) onDiscountChanged;
  final Function(double) onReceivedChanged;
  final VoidCallback onCheckout;
  final VoidCallback onShare;
  final VoidCallback onClear;

  const _CartPanel({
    required this.cart,
    required this.customers,
    required this.selectedCustomer,
    required this.onCustomerChanged,
    required this.onUpdateQuantity,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.received,
    required this.change,
    required this.onDiscountChanged,
    required this.onReceivedChanged,
    required this.onCheckout,
    required this.onShare,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xFF0A1931),
          child: Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Active Checkout',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70),
                onPressed: onClear,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Customer>(
              isExpanded: true,
              hint: const Text('Walk-in Customer'),
              value: selectedCustomer,
              items: [
                const DropdownMenuItem<Customer>(value: null, child: Text('Walk-in Customer')),
                ...customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))),
              ],
              onChanged: onCustomerChanged,
            ),
          ),
        ),
        Expanded(
          child: cart.isEmpty 
            ? const Center(child: Text('Cart is empty'))
            : Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return _CartItemRow(
                      item: item,
                      onRemove: () => onUpdateQuantity(index, -1),
                      onAdd: () => onUpdateQuantity(index, 1),
                    );
                  },
                ),
              ),
        ),
        SingleChildScrollView(
          child: _BillingSummary(
            paymentMethod: paymentMethod,
            onPaymentMethodChanged: onPaymentMethodChanged,
            subtotal: subtotal,
            discount: discount,
            total: total,
            received: received,
            change: change,
            onDiscountChanged: onDiscountChanged,
            onReceivedChanged: onReceivedChanged,
            onCheckout: onCheckout,
            onShare: onShare,
          ),
        ),
      ],
    );
  }
}

class _CatalogItemCard extends StatelessWidget {
  final Product product;
  final bool isOutOfStock;
  final VoidCallback onTap;

  const _CatalogItemCard({required this.product, required this.isOutOfStock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isOutOfStock ? Colors.red.withValues(alpha: 0.2) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      color: isOutOfStock ? Colors.red.withValues(alpha: 0.02) : Colors.white,
      child: InkWell(
        onTap: isOutOfStock ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: product.type == 'book' ? const Color(0xFFEFF6FF) : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      product.type == 'book' ? Icons.menu_book : Icons.edit_note, 
                      size: 18, 
                      color: product.type == 'book' ? const Color(0xFF2563EB) : const Color(0xFFD97706),
                    ),
                  ),
                  const Spacer(),
                  if (isOutOfStock)
                    const Text('OUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10))
                  else
                    Text('QTY: ${product.stockQuantity}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (product.courseOrCategory != null && product.courseOrCategory!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.courseOrCategory!,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.rackLocation != null)
                        Text('Rack: ${product.rackLocation}', style: const TextStyle(fontSize: 9, color: Colors.grey)),
                      Text(
                        'Rs. ${product.salePrice}',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const _CartItemRow({required this.item, required this.onRemove, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final product = item['product'] as Product;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              Text('Rs. ${product.salePrice * item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text('Rs. ${product.salePrice} / unit', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.remove_circle_outline, size: 18), onPressed: onRemove),
              Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline, size: 18), onPressed: onAdd),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingSummary extends StatelessWidget {
  final String paymentMethod;
  final Function(String) onPaymentMethodChanged;
  final double subtotal;
  final double discount;
  final double total;
  final double received;
  final double change;
  final Function(double) onDiscountChanged;
  final Function(double) onReceivedChanged;
  final VoidCallback onCheckout;
  final VoidCallback onShare;

  const _BillingSummary({
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.received,
    required this.change,
    required this.onDiscountChanged,
    required this.onReceivedChanged,
    required this.onCheckout,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          // Payment Method Selector
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Cash Sale')),
                  selected: paymentMethod == 'Cash',
                  onSelected: (val) {
                    if (val) onPaymentMethodChanged('Cash');
                  },
                  selectedColor: const Color(0xFF185ADB).withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: paymentMethod == 'Cash' ? const Color(0xFF185ADB) : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Khata (Credit)')),
                  selected: paymentMethod == 'Khata',
                  onSelected: (val) {
                    if (val) onPaymentMethodChanged('Khata');
                  },
                  selectedColor: Colors.red.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: paymentMethod == 'Khata' ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _rowSummary('Subtotal', 'Rs. $subtotal'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Discount', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => onDiscountChanged(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _rowSummary('Total Pay', 'Rs. $total', isBold: true, fontSize: 18),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Received', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => onReceivedChanged(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _rowSummary('Change Due', 'Rs. $change', color: Colors.green),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: subtotal > 0 ? onCheckout : null,
              child: const Text('Complete & Print'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: subtotal > 0 ? onShare : null,
              icon: const Icon(Icons.share, size: 16),
              label: const Text('Share Receipt'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowSummary(String label, String val, {bool isBold = false, double fontSize = 14, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(val, style: GoogleFonts.inter(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
      ],
    );
  }
}
