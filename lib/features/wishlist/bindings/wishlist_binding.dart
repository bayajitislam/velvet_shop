import 'package:get/get.dart';
import 'package:velvet/features/wishlist/controllers/wishlist_controller.dart';
import 'package:velvet/features/wishlist/repositories/wishlist_repository.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistRepository>(() => WishlistRepository());
    Get.lazyPut<WishlistController>(() => WishlistController(repo: Get.find()));
  }
}
