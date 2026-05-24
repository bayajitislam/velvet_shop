import 'package:velvet/features/cart/models/cart_item_model.dart';

// ─────────────────────────────────────────────────────────
//  CartRepository
//
//  Currently: in-memory
//  Later: swap with local DB (Hive/Isar) or API
// ─────────────────────────────────────────────────────────

class CartRepository {
  final List<CartItemModel> _items = [];

  List<CartItemModel> getItems() => List.unmodifiable(_items);

  // Add or increase quantity if same product+size exists
  void addItem(CartItemModel newItem) {
    final index = _items.indexWhere((i) => i.id == newItem.id);
    if (index >= 0) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
  }

  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index >= 0) _items[index].quantity++;
  }

  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  void clear() => _items.clear();
}