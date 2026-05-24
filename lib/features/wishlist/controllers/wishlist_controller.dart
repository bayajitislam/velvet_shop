import 'package:get/get.dart';
import 'package:velvet/core/utils/debug_console.dart';
import 'package:velvet/features/home/models/product_model.dart';
import 'package:velvet/features/wishlist/repositories/wishlist_repository.dart';

// ─────────────────────────────────────────────────────────
//  WishlistController
// ─────────────────────────────────────────────────────────

class WishlistController extends GetxController {
  final WishlistRepository repo;

  WishlistController({required this.repo});

  // Observable list — UI rebuilds automatically on change
  final RxList<ProductModel> items = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
  }

  void _loadItems() {
    items.assignAll(repo.getItems());
  }

  // ── Toggle wishlist (used from ProductCard + ProductDetail) ─
  void toggle(ProductModel product) {
    if (isWishlisted(product.id)) {
      remove(product);
    } else {
      add(product);
    }
  }

  void add(ProductModel product) {
    repo.add(product);
    items.assignAll(repo.getItems());
    DebugConsole.info('Added to wishlist: ${product.name}');
  }

  void remove(ProductModel product) {
    repo.remove(product.id);
    items.assignAll(repo.getItems());
  }

  void clearAll() {
    repo.clear();
    items.clear();
  }

  bool isWishlisted(String productId) => repo.contains(productId);
}
