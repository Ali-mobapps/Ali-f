import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../../../core/database/database_helper.dart';

class AddProductDialog extends StatefulWidget {
  final String type; // 'book' or 'stationery'
  final VoidCallback onAdded;

  const AddProductDialog({super.key, required this.type, required this.onAdded});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _rackController = TextEditingController();
  final _costController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.type == 'book' ? 'Book' : 'Stationery'}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              if (widget.type == 'book') TextFormField(controller: _courseController, decoration: const InputDecoration(labelText: 'Class/Category')),
              TextFormField(controller: _rackController, decoration: const InputDecoration(labelText: 'Rack Location')),
              TextFormField(controller: _costController, decoration: const InputDecoration(labelText: 'Purchase Price'), keyboardType: TextInputType.number),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Selling Price'), keyboardType: TextInputType.number),
              TextFormField(controller: _stockController, decoration: const InputDecoration(labelText: 'Stock Quantity'), keyboardType: TextInputType.number),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final product = Product(
                id: const Uuid().v4(),
                name: _nameController.text,
                type: widget.type,
                courseOrCategory: _courseController.text,
                rackLocation: _rackController.text,
                costPrice: double.tryParse(_costController.text) ?? 0.0,
                salePrice: double.tryParse(_priceController.text) ?? 0.0,
                stockQuantity: int.tryParse(_stockController.text) ?? 0,
              );
              await DatabaseHelper().insertProduct(product.toMap());
              widget.onAdded();
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
