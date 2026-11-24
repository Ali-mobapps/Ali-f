import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product; // null if adding new, non-null if editing

  const AddEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _imageController;
  late TextEditingController _stockController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toString() : '');
    _categoryController = TextEditingController(text: p?.category ?? 'Formal');
    _imageController = TextEditingController(text: p?.imagePath ?? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80');
    _stockController = TextEditingController(text: p != null ? p.stockQuantity.toString() : '10');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2D52),
        title: Text(isEditing ? 'Edit Product' : 'Add New Product', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Watch Name',
                prefixIcon: Icons.watch,
                validator: (val) => val == null || val.isEmpty ? 'Enter watch name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _categoryController,
                labelText: 'Category (Formal, Sport, Casual, Premium)',
                prefixIcon: Icons.category,
                validator: (val) => val == null || val.isEmpty ? 'Enter category' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                labelText: 'Price (PKR)',
                prefixIcon: Icons.money,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null ? 'Enter valid price' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _stockController,
                labelText: 'Stock Quantity',
                prefixIcon: Icons.inventory,
                keyboardType: TextInputType.number,
                validator: (val) => val == null || int.tryParse(val) == null ? 'Enter valid stock' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageController,
                labelText: 'Image URL',
                prefixIcon: Icons.image,
                validator: (val) => val == null || val.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                labelText: 'Description',
                prefixIcon: Icons.description,
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: isEditing ? 'Update Product' : 'Save Product',
                isGold: true,
                isLoading: _isSaving,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isSaving = true);
                    final productProvider = Provider.of<ProductProvider>(context, listen: false);

                    final product = Product(
                      productId: widget.product?.productId,
                      name: _nameController.text,
                      description: _descController.text,
                      price: double.parse(_priceController.text),
                      category: _categoryController.text,
                      imagePath: _imageController.text,
                      stockQuantity: int.parse(_stockController.text),
                    );

                    if (isEditing) {
                      await productProvider.updateProduct(product);
                    } else {
                      await productProvider.addProduct(product);
                    }

                    setState(() => _isSaving = false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEditing ? 'Product updated successfully!' : 'Product added successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
