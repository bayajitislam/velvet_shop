import 'package:get/get.dart';
import 'package:velvet/features/cart/models/cart_item_model.dart';
import 'package:velvet/features/cart/repositories/cart_repository.dart';

// ─────────────────────────────────────────────────────────
//  CartController
// ─────────────────────────────────────────────────────────

class CartController extends GetxController {
  final CartRepository repo;

  CartController({required this.repo});

  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  // Computed observables
  final RxDouble subtotal = 0.0.obs;
  final RxInt totalItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  void _loadItems() {
    items.assignAll(repo.getItems());
    _updateTotals();
  }

  void _updateTotals() {
    subtotal.value = repo.subtotal;
    totalItems.value = repo.totalItems;
  }

  // ── Add item (called from ProductDetailPage) ───────────
  void addItem(CartItemModel item) {
    repo.addItem(item);
    _loadItems();
  }

  void removeItem(CartItemModel item) {
    repo.removeItem(item.id);
    _loadItems();
  }

  void increment(CartItemModel item) {
    repo.incrementQuantity(item.id);
    _loadItems();
  }

  void decrement(CartItemModel item) {
    repo.decrementQuantity(item.id);
    _loadItems();
  }

  void clearCart() {
    repo.clear();
    items.clear();
    _updateTotals();
  }

  bool get isEmpty => items.isEmpty;
}
