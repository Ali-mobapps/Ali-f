import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Formal', 'Sport', 'Casual', 'Premium'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2D52),
        title: const Text('Watch Catalogue', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products;

          return Column(
            children: [
              // Search & Filter header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => productProvider.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search watches by name or features...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF0F2D52)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = productProvider.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: const Color(0xFF0F2D52),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF1F2937),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                productProvider.setSelectedCategory(cat);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Product Grid
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          'No watches found matching your criteria.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
