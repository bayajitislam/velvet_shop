import 'package:get/get.dart';
import 'package:velvet/features/auth/controllers/auth_controller.dart';
import 'package:velvet/features/auth/repositories/auth_repository.dart';
import 'package:velvet/features/cart/controllers/cart_controller.dart';
import 'package:velvet/features/cart/repositories/cart_repository.dart';
import 'package:velvet/features/home/repositories/home_repository.dart';
import 'package:velvet/features/wishlist/controllers/wishlist_controller.dart';
import 'package:velvet/features/wishlist/repositories/wishlist_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Auth, Cart, Wishlist must be registered BEFORE HomeController
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => CartRepository());
    Get.lazyPut(() => WishlistRepository());
    Get.lazyPut(() => AuthController(repo: Get.find()));
    Get.lazyPut(() => CartController(repo: Get.find()));
    Get.lazyPut(() => WishlistController(repo: Get.find()));
    Get.lazyPut(() => HomeRepository());
    Get.lazyPut(() => HomeController(repo: Get.find()));
  }
}
