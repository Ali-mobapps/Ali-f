import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../database/database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products {
    List<Product> list = _products;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      list = list.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                              p.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return list;
  }

  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await DatabaseHelper.instance.getProducts();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await DatabaseHelper.instance.insertProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper.instance.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int productId) async {
    await DatabaseHelper.instance.deleteProduct(productId);
    await fetchProducts();
  }
}
