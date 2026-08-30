import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
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
  String _manualCustomerName = '';
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  
  late Timer _timer;
  DateTime _now = DateTime.now();

  double _discount = 0.0;
  double _received = 0.0;
  String _paymentMethod = 'Cash'; // 'Cash', 'Khata', or 'Online'

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    _customerNameController.dispose();
    super.dispose();
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

  // Helper to get remaining stock for display in the grid
  int _getDisplayStock(Product product) {
    final cartItem = _cart.firstWhereOrNull((item) => item['product'].id == product.id);
    if (cartItem != null) {
      return product.stockQuantity - (cartItem['quantity'] as int);
    }
    return product.stockQuantity;
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

  void _removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
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
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final displayStock = _getDisplayStock(product);
                      final bool isOutOfStock = displayStock <= 0;
                      return _CatalogItemCard(
                        product: product,
                        displayStock: displayStock,
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
                customerNameController: _customerNameController,
                currentTime: _now,
                onCustomerChanged: (val) {
                  setState(() {
                    _selectedCustomer = val;
                    if (val != null) {
                      _customerNameController.text = val.name;
                    }
                  });
                },
                onUpdateQuantity: _updateQuantity,
                onDeleteItem: _removeItem,
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
            customerNameController: _customerNameController,
            currentTime: _now,
            onCustomerChanged: (val) {
              setState(() {
                _selectedCustomer = val;
                if (val != null) {
                  _customerNameController.text = val.name;
                }
              });
              setModalState(() {});
            },
            onUpdateQuantity: (idx, delta) {
              _updateQuantity(idx, delta);
              setModalState(() {});
            },
            onDeleteItem: (idx) {
              _removeItem(idx);
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

    if (_paymentMethod == 'Online' && _selectedCustomer == null) {
      Get.snackbar('Online Order', 'Please select or add a customer to record the shipping address',
          backgroundColor: Colors.purple, colorText: Colors.white);
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
                  'total_balance': 0.0,
                };
                try {
                  final savedCustomer = await _db.insertCustomer(customerData);
                  setState(() {
                    _selectedCustomer = Customer.fromMap(savedCustomer);
                    _customers.add(_selectedCustomer!);
                    _customerNameController.text = _selectedCustomer!.name;
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                    _processCheckout();
                  }
                } catch (e) {
                  if (context.mounted) {
                    Get.snackbar('Error', 'Failed to create customer: $e', 
                      backgroundColor: Colors.red, colorText: Colors.white);
                  }
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
    final String customerName = _customerNameController.text.isNotEmpty 
        ? _customerNameController.text 
        : (_selectedCustomer?.name ?? 'Walk-in');

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
    
    // Create a temporary customer object if one isn't selected but a name is typed
    final displayCustomer = _selectedCustomer ?? (_customerNameController.text.isNotEmpty 
        ? Customer(id: '', name: _customerNameController.text, phone: '', address: '', totalBalance: 0) 
        : null);

    await PdfGenerator.generateAndPrintBill(
      billId: saleId,
      subtotal: _subtotal,
      discount: _discount,
      total: _total,
      cart: _cart,
      customer: displayCustomer,
    );
    
    if (!mounted) return;
    setState(() {
      _cart.clear();
      _discount = 0;
      _received = 0;
      _selectedCustomer = null;
      _customerNameController.clear();
      _paymentMethod = 'Cash';
    });
    _loadData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Complete & Receipt Printed!'))
    );
  }

  void _shareReceipt() async {
    if (_cart.isEmpty) return;
    final itemsText = _cart.map((i) => "• ${i['product'].name}\n  ${i['quantity']} x Rs. ${i['product'].salePrice} = Rs. ${i['product'].salePrice * i['quantity']}").join("\n\n");
    
    final String customerName = _customerNameController.text.isNotEmpty 
        ? _customerNameController.text 
        : (_selectedCustomer?.name ?? 'Walk-in');

    final shareText = "✨ *LOCAL SHOP STORE* ✨\n"
        "----------------------------\n"
        "🧾 *SALES RECEIPT*\n"
        "📅 Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}\n"
        "👤 Customer: $customerName\n"
        "----------------------------\n"
        "$itemsText\n"
        "----------------------------\n"
        "💰 *Total Amount: Rs. $_total*\n"
        "💳 Payment: $_paymentMethod\n"
        "----------------------------\n"
        "🙏 Thank you for your business!";
        
    await Share.share(shareText);
  }
}

class _CartPanel extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final TextEditingController customerNameController;
  final DateTime currentTime;
  final Function(Customer?) onCustomerChanged;
  final Function(int, int) onUpdateQuantity;
  final Function(int) onDeleteItem;
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
    super.key,
    required this.cart,
    required this.customers,
    required this.selectedCustomer,
    required this.customerNameController,
    required this.currentTime,
    required this.onCustomerChanged,
    required this.onUpdateQuantity,
    required this.onDeleteItem,
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
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF0F172A),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.store_rounded, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'LOCAL SHOP STORE',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('HH:mm:ss').format(currentTime),
                    style: GoogleFonts.jetBrainsMono(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 22),
                    onPressed: onClear,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Clear Cart',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Customer>(
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1E293B),
                          iconEnabledColor: Colors.white70,
                          hint: const Text('Select Customer', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          value: selectedCustomer,
                          items: [
                            const DropdownMenuItem<Customer>(value: null, child: Text('New/Walk-in', style: TextStyle(color: Colors.white))),
                            ...customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(color: Colors.white)))),
                          ],
                          onChanged: onCustomerChanged,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: customerNameController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Customer Name',
                          hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(currentTime),
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ),
        Expanded(
          child: cart.isEmpty 
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Cart is empty', style: TextStyle(color: Colors.grey)),
                ],
              ))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: cart.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return _CartItemRow(
                    item: item,
                    onRemove: () => onUpdateQuantity(index, -1),
                    onAdd: () => onUpdateQuantity(index, 1),
                    onDelete: () => onDeleteItem(index),
                  );
                },
              ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
            ],
          ),
          child: SingleChildScrollView(
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
        ),
      ],
    );
  }
}

class _CatalogItemCard extends StatelessWidget {
  final Product product;
  final int displayStock;
  final bool isOutOfStock;
  final VoidCallback onTap;

  const _CatalogItemCard({
    required this.product, 
    required this.displayStock,
    required this.isOutOfStock, 
    required this.onTap
  });

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
                    Text('QTY: $displayStock', style: const TextStyle(color: Colors.grey, fontSize: 10)),
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
  final VoidCallback onDelete;

  const _CartItemRow({
    required this.item, 
    required this.onRemove, 
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final product = item['product'] as Product;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.courseOrCategory != null)
                      Text(
                        product.courseOrCategory!,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: onRemove),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${item['quantity']}', 
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)
                    ),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: onAdd),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${product.salePrice} / unit', 
                    style: const TextStyle(fontSize: 10, color: Colors.grey)
                  ),
                  Text(
                    'Rs. ${product.salePrice * item['quantity']}', 
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A))
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _QtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF0F172A)),
      ),
    );
  }
}

class _BillingSummary extends StatefulWidget {
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
    super.key,
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
  State<_BillingSummary> createState() => _BillingSummaryState();
}

class _BillingSummaryState extends State<_BillingSummary> {
  final TextEditingController _receivedCtrl = TextEditingController();
  final TextEditingController _discountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _receivedCtrl.text = widget.received > 0 ? widget.received.toStringAsFixed(0) : '';
    _discountCtrl.text = widget.discount > 0 ? widget.discount.toStringAsFixed(0) : '';
  }

  @override
  void didUpdateWidget(_BillingSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.received == 0 && _receivedCtrl.text.isNotEmpty) _receivedCtrl.clear();
    if (widget.discount == 0 && _discountCtrl.text.isNotEmpty) _discountCtrl.clear();
  }

  @override
  void dispose() {
    _receivedCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _MethodChip(label: 'Cash', method: 'Cash', current: widget.paymentMethod, color: const Color(0xFF185ADB), onSelected: widget.onPaymentMethodChanged),
              const SizedBox(width: 4),
              _MethodChip(label: 'Khata', method: 'Khata', current: widget.paymentMethod, color: Colors.red, onSelected: widget.onPaymentMethodChanged),
              const SizedBox(width: 4),
              _MethodChip(label: 'Online', method: 'Online', current: widget.paymentMethod, color: Colors.purple, onSelected: widget.onPaymentMethodChanged),
            ],
          ),
          const SizedBox(height: 8),
          _rowSummary('Subtotal', 'Rs. ${widget.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Discount', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: _discountCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (v) => widget.onDiscountChanged(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          _rowSummary('Total Payable', 'Rs. ${widget.total.toStringAsFixed(0)}', isBold: true, fontSize: 14),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Received', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: _receivedCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (v) => widget.onReceivedChanged(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      hintText: 'Cash Paid',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _rowSummary('Change Due', 'Rs. ${widget.change.toStringAsFixed(0)}', color: Colors.green, isBold: true, fontSize: 13),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: widget.subtotal > 0 ? widget.onCheckout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Complete & Print', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              onPressed: widget.subtotal > 0 ? widget.onShare : null,
              icon: const Icon(Icons.share_outlined, size: 14),
              label: const Text('Share Receipt', style: TextStyle(fontSize: 11)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _MethodChip({required String label, required String method, required String current, required Color color, required Function(String) onSelected}) {
    final bool isSelected = current == method;
    return Expanded(
      child: ChoiceChip(
        label: Center(child: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
        selected: isSelected,
        onSelected: (val) { if (val) onSelected(method); },
        selectedColor: color.withValues(alpha: 0.1),
        labelStyle: TextStyle(color: isSelected ? color : Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _rowSummary(String label, String val, {bool isBold = false, double fontSize = 13, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: isBold ? const Color(0xFF0F172A) : Colors.grey)),
        Text(val, style: GoogleFonts.plusJakartaSans(fontSize: fontSize, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, color: color ?? const Color(0xFF0F172A))),
      ],
    );
  }
}
