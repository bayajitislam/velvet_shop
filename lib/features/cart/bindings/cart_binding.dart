import 'package:get/get.dart';
import 'package:velvet/features/cart/controllers/cart_controller.dart';
import 'package:velvet/features/cart/repositories/cart_repository.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRepository>(() => CartRepository());
    Get.lazyPut<CartController>(() => CartController(repo: Get.find()));
  }
}
