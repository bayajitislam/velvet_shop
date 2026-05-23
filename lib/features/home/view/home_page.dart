import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/core/widgets/custom_bottom_nav_bar.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';
import 'package:velvet/features/home/view/cart_page.dart';
import 'package:velvet/features/home/view/profile_page.dart';
import 'package:velvet/features/home/view/wishlist_page.dart';
import 'package:velvet/features/home/widgets/filter_bottom_sheet.dart';
import 'package:velvet/features/home/widgets/home_app_bar.dart';
import 'package:velvet/features/home/widgets/home_banner_slider.dart';
import 'package:velvet/features/home/widgets/home_category_chips.dart';
import 'package:velvet/features/home/widgets/home_search_bar.dart';
import 'package:velvet/features/home/widgets/product_card.dart';

// ── Dummy pages (imported from their own files) ──────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // All 4 tab bodies — index maps to bottom nav
  static final List<Widget> _pages = [
    const _HomeBody(), // 0 – Home
    const WishlistPage(), // 1 – Wishlist
    const CartPage(), // 2 – Cart
    const ProfilePage(), // 3 – Profile
  ];

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available (registered in HomeBinding)
    final c = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      body: Obx(
        () => Stack(
          children: [
            // ── Active tab body ──
            IndexedStack(index: c.selectedNavIndex.value, children: _pages),

            // ── Floating bottom nav (always visible) ──
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 24,
              right: 24,
              child: const CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Home tab body
// ─────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  void _showFilter() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final topPad = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      slivers: [
        // Status bar spacer
        SliverToBoxAdapter(child: SizedBox(height: topPad + 12)),

        // App bar
        const SliverToBoxAdapter(child: HomeAppBar()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Search bar
        SliverToBoxAdapter(child: HomeSearchBar(onFilterTap: _showFilter)),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Banner slider
        const SliverToBoxAdapter(child: HomeBannerSlider()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Categories
        const SliverToBoxAdapter(child: HomeCategoryChips()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Popular products header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.homePopular, style: AppTextStyle.s16w6()),
                GestureDetector(
                  onTap: _showFilter,
                  child: Text(
                    'See All',
                    style: AppTextStyle.s14w4(color: AppPallete.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // Product list — single column, full width cards
        Obx(() {
          if (c.isProductLoading.value) {
            return const SliverToBoxAdapter(child: _ProductSkeleton());
          }
          if (c.products.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text('No products found', style: AppTextStyle.s14w4()),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((_, i) {
              final product = c.products[i];
              // Extra bottom padding on last item for nav bar
              final isLast = i == c.products.length - 1;
              return Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, isLast ? 110 : 12),
                child: ProductCard(
                  product: product,
                  onTap: () => c.onProductTap(product),
                  onFavoriteTap: () => c.toggleFavorite(product),
                ),
              );
            }, childCount: c.products.length),
          );
        }), // unwrap Obx for SliverList compatibility
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Product list skeleton loader
// ─────────────────────────────────────────────────────────

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppPallete.background,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
