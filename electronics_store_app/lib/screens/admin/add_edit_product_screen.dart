import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../utils/validators.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _stockController;
  String _selectedCategory = 'Smartphones';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _imageController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _selectedCategory = widget.product?.category ?? 'Smartphones';

    _imageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final now = DateTime.now().toIso8601String();

      final product = ProductModel(
        id: widget.product?.id,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        imageUrl: _imageController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        rating: widget.product?.rating ?? 4.5,
        createdAt: widget.product?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.product == null) {
        await productProvider.addProduct(product);
      } else {
        await productProvider.updateProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null ? 'Product added successfully!' : 'Product updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = productProvider.categories.where((c) => c != 'All').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add New Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
                validator: (v) => Validators.validateRequired(v, 'Product Name'),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              // Price & Stock Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price (\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (v) => Validators.validateNumber(v, 'Price'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock Qty',
                        prefixIcon: Icon(Icons.inventory_outlined),
                      ),
                      validator: (v) => Validators.validateNumber(v, 'Stock'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image URL Field
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Picture / Image URL',
                  prefixIcon: Icon(Icons.image_outlined),
                  hintText: 'https://images.unsplash.com/...',
                ),
                validator: (v) => Validators.validateRequired(v, 'Image URL'),
              ),

              // Live Image Preview Container
              if (_imageController.text.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageController.text.trim(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Text(
                          'Invalid Image URL',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) => Validators.validateRequired(v, 'Description'),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: Text(
                  widget.product == null ? 'Add Product to Store' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
