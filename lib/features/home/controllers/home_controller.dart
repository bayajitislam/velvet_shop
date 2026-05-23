import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/features/home/models/bennar_model.dart';
import 'package:velvet/features/home/models/product_model.dart';
import 'package:velvet/features/home/repositories/home_repository.dart';
import 'package:velvet/features/splash/controllers/splash_controller.dart';
import 'package:velvet/routes/routes_name.dart';

class HomeController extends GetxController {
  final HomeRepository repo;

  HomeController({required this.repo});

  // ── Auth state ─────────────────────────────────────────
  final RxBool isLoggedIn = false.obs;
  final RxString userName = ''.obs;

  // ── Loading states ─────────────────────────────────────
  final RxBool isBannerLoading = true.obs;
  final RxBool isProductLoading = true.obs;

  // ── Data ───────────────────────────────────────────────
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // ── UI state ───────────────────────────────────────────
  final RxInt currentBannerIndex = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedNavIndex = 0.obs;

  final PageController bannerPageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _loadData();
  }

  @override
  void onClose() {
    bannerPageController.dispose();
    super.onClose();
  }

  // ── Auth ───────────────────────────────────────────────
  void _checkAuthState() {
    final token = SplashController.readToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
    if (isLoggedIn.value) {
      // Replace with actual user name from storage/profile
      userName.value = 'Bayajit Islam';
    }
  }

  // ── Data Loading ───────────────────────────────────────
  Future<void> _loadData() async {
    await Future.wait([_loadBanners(), _loadCategories(), _loadProducts()]);
  }

  Future<void> _loadBanners() async {
    try {
      isBannerLoading.value = true;
      final data = await repo.fetchBanners();
      banners.assignAll(data);
    } catch (e) {
      debugPrint('Banner load error: $e');
    } finally {
      isBannerLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final data = await repo.fetchCategories();
      categories.assignAll(data);
    } catch (e) {
      debugPrint('Category load error: $e');
    }
  }

  Future<void> _loadProducts({String category = 'Discover'}) async {
    try {
      isProductLoading.value = true;
      final data = await repo.fetchProducts(category: category);
      products.assignAll(data);
    } catch (e) {
      debugPrint('Product load error: $e');
    } finally {
      isProductLoading.value = false;
    }
  }

  // ── UI Actions ─────────────────────────────────────────
  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
    final cat = categories.isNotEmpty ? categories[index] : 'Discover';
    _loadProducts(category: cat);
  }

  void onNavItemTapped(int index) {
    selectedNavIndex.value = index;
  }

  void toggleFavorite(ProductModel product) {
    if (!isLoggedIn.value) {
      showAuthPrompt(RoutesName.wishlist);
      return;
    }
    final i = products.indexWhere((p) => p.id == product.id);
    if (i != -1) {
      products[i].isFavorite = !products[i].isFavorite;
      products.refresh();
    }
  }

  void onProductTap(ProductModel product) {
    Get.toNamed(RoutesName.productDetails, arguments: product);
  }

  void onCartTap() {
    if (!isLoggedIn.value) {
      showAuthPrompt(RoutesName.cart);
      return;
    }
    selectedNavIndex.value = 2;
  }

  // ── Auth Guard ─────────────────────────────────────────
  /// Show the middleware bottom sheet for any protected route
  void showAuthPrompt(String route) {
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.bottomSheet(
        _buildLoginPrompt(route),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    });
  }

  Widget _buildLoginPrompt(String route) {
    final featureNames = {
      RoutesName.cart: 'your cart',
      RoutesName.wishlist: 'your wishlist',
      RoutesName.checkout: 'checkout',
      RoutesName.profile: 'your profile',
    };
    final feature = featureNames[route] ?? 'this feature';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 +
            (Get.context != null
                ? MediaQuery.of(Get.context!).padding.bottom
                : 0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFE91E63),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sign in required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You need to be signed in to access $feature.\nBrowsing & viewing products is free!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(RoutesName.login, arguments: {'redirect': route});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF8BBD0), width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue Browsing',
                style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
