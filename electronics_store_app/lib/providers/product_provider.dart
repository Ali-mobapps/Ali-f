import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepo = ProductRepository();
  List<ProductModel> _products = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'newest';
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    try {
      final cats = await _productRepo.getCategories();
      _categories = ['All', ...cats];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productRepo.getProducts(
        category: _selectedCategory,
        searchQuery: _searchQuery,
        sortBy: _sortBy,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching products: $e');
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchProducts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchProducts();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    fetchProducts();
  }

  Future<void> addProduct(ProductModel product) async {
    await _productRepo.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _productRepo.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _productRepo.deleteProduct(id);
    await fetchProducts();
  }
}
