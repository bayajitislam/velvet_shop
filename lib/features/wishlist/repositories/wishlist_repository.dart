import 'package:velvet/features/home/models/product_model.dart';

// ─────────────────────────────────────────────────────────
//  WishlistRepository
//
//  Currently: in-memory (no backend)
//  Later: swap fetchWishlist / addToWishlist / removeFromWishlist
//  with real API calls — controller stays the same
// ─────────────────────────────────────────────────────────

class WishlistRepository {
  // In-memory store (replace with SharedPreferences or API later)
  final List<ProductModel> _items = [];

  List<ProductModel> getItems() => List.unmodifiable(_items);

  void add(ProductModel product) {
    final exists = _items.any((p) => p.id == product.id);
    if (!exists) _items.add(product);
  }

  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
  }

  bool contains(String productId) {
    return _items.any((p) => p.id == productId);
  }

  void clear() => _items.clear();
}