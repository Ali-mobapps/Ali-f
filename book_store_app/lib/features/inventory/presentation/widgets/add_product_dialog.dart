import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../../../core/database/supabase_helper.dart';

class AddProductDialog extends StatefulWidget {
  final String type; // 'book' or 'stationery'
  final Product? product; // If provided, we are editing
  final VoidCallback onAdded;

  const AddProductDialog({super.key, required this.type, this.product, required this.onAdded});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _courseController;
  late TextEditingController _rackController;
  late TextEditingController _costController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _thresholdController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _courseController = TextEditingController(text: widget.product?.courseOrCategory ?? '');
    _rackController = TextEditingController(text: widget.product?.rackLocation ?? '');
    _costController = TextEditingController(text: widget.product?.costPrice.toString() ?? '');
    _priceController = TextEditingController(text: widget.product?.salePrice.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '0');
    _thresholdController = TextEditingController(text: widget.product?.minStockThreshold.toString() ?? '3');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _rackController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.product != null;
    return AlertDialog(
      title: Text('${isEditing ? 'Edit' : 'Add'} ${widget.type == 'book' ? 'Book' : 'Stationery'}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController, 
                decoration: const InputDecoration(labelText: 'Name/Title', border: OutlineInputBorder()), 
                validator: (v) => v!.isEmpty ? 'Required' : null
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController, 
                decoration: InputDecoration(labelText: widget.type == 'book' ? 'Class/Course' : 'Category', border: const OutlineInputBorder())
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rackController, 
                decoration: const InputDecoration(labelText: 'Rack/Shelf Location', border: OutlineInputBorder())
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _costController, 
                      decoration: const InputDecoration(labelText: 'Cost Price', border: OutlineInputBorder()), 
                      keyboardType: TextInputType.number
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController, 
                      decoration: const InputDecoration(labelText: 'Sale Price', border: OutlineInputBorder()), 
                      keyboardType: TextInputType.number
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController, 
                      decoration: const InputDecoration(labelText: 'Stock Qty', border: OutlineInputBorder()), 
                      keyboardType: TextInputType.number
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _thresholdController, 
                      decoration: const InputDecoration(labelText: 'Alert At', border: OutlineInputBorder()), 
                      keyboardType: TextInputType.number
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() => _isLoading = true);
              try {
                final product = Product(
                  id: widget.product?.id ?? const Uuid().v4(),
                  name: _nameController.text,
                  type: widget.type,
                  courseOrCategory: _courseController.text,
                  rackLocation: _rackController.text,
                  costPrice: double.tryParse(_costController.text) ?? 0.0,
                  salePrice: double.tryParse(_priceController.text) ?? 0.0,
                  stockQuantity: int.tryParse(_stockController.text) ?? 0,
                  minStockThreshold: int.tryParse(_thresholdController.text) ?? 3,
                );
                
                final navigator = Navigator.of(context);
                if (isEditing) {
                  await SupabaseHelper().updateProduct(product.toMap());
                } else {
                  await SupabaseHelper().insertProduct(product.toMap());
                }
                
                widget.onAdded();
                navigator.pop();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            }
          },
          child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Save'),
        ),
      ],
    );
  }
}
