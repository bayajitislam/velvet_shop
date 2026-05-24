import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:velvet/features/auth/bindings/auth_binding.dart';
import 'package:velvet/features/auth/view/login_page.dart';
import 'package:velvet/features/auth/view/signup_page.dart';
import 'package:velvet/features/cart/bindings/cart_binding.dart';
import 'package:velvet/features/cart/view/cart_page.dart';
import 'package:velvet/features/home/bindings/home_binding.dart';
import 'package:velvet/features/home/view/home_page.dart';
import 'package:velvet/features/home/view/product_details.dart';
import 'package:velvet/features/splash/view/splash_page.dart';
import 'package:velvet/features/wishlist/bindings/wishlist_binding.dart';
import 'package:velvet/features/wishlist/view/wishlist_page.dart';
import 'package:velvet/routes/routes_name.dart';

class AppRoutes {
  static List<GetPage> routes = [
    GetPage(name: RoutesName.splash, page: () => SplashPage()),
    GetPage(
      name: RoutesName.home,
      page: () => HomePage(),
      binding: 
        HomeBinding(),

      
    ),
    GetPage(
      name: RoutesName.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.signup,
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: RoutesName.productDetails, page: () => ProductDetailPage()),
    GetPage(
      name: RoutesName.cart,
      page: () => CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: RoutesName.wishlist,
      page: () => WishlistPage(),
      binding: WishlistBinding(),
    ),
  ];
}
