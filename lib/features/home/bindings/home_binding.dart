import 'package:get/get.dart';
import 'package:velvet/features/home/repositories/home_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    Get.lazyPut<HomeController>(() => HomeController(repo: Get.find()));
  }
}
