import 'package:get/get.dart';
import 'package:velvet/features/auth/controllers/auth_controller.dart';
import 'package:velvet/features/auth/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AuthController>(() => AuthController(repo: Get.find()));
  }
}
