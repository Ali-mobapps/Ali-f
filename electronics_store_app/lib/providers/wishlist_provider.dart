import 'package:flutter/material.dart';
import '../models/wishlist_model.dart';
import '../repositories/wishlist_repository.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistRepository _wishlistRepo = WishlistRepository();
  List<WishlistModel> _wishlistItems = [];
  bool _isLoading = false;

  List<WishlistModel> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;

  Future<void> fetchWishlist(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _wishlistItems = await _wishlistRepo.getWishlist(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching wishlist: $e');
    }
  }

  Future<bool> isInWishlist(int userId, int productId) async {
    return await _wishlistRepo.isInWishlist(userId, productId);
  }

  Future<void> toggleWishlist(int userId, int productId) async {
    try {
      await _wishlistRepo.toggleWishlist(userId, productId);
      await fetchWishlist(userId);
    } catch (e) {
      rethrow;
    }
  }
}
