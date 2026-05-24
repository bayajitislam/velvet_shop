import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/core/widgets/primary_button.dart';
import 'package:velvet/features/home/widgets/product_card.dart';
import 'package:velvet/features/wishlist/controllers/wishlist_controller.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  WishlistPage
//
//  • Same ProductCard grid as Home screen
//  • Empty state with illustration + CTA
//  • Animated item removal on un-favorite
// ─────────────────────────────────────────────────────────

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('Wishlist', style: AppTextStyle.s16w6()),
        actions: [
          Obx(
            () => c.items.isNotEmpty
                ? TextButton(
                    onPressed: c.clearAll,
                    child: Text(
                      'Clear all',
                      style: AppTextStyle.s12w5(color: AppPallete.primary),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (c.items.isEmpty) return const _EmptyWishlist();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: 0.62, // same ratio as home grid
            ),
            itemCount: c.items.length,
            itemBuilder: (_, i) {
              final product = c.items[i];
              return ProductCard(
                product: product,
                onTap: () =>
                    Get.toNamed(RoutesName.productDetails, arguments: product),
                onFavoriteTap: () => c.remove(product),
              );
            },
          ),
        );
      }),
    );
  }
}

// ── Empty state ────────────────────────────────────────────
class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppPallete.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: AppPallete.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Your wishlist is empty',
              style: AppTextStyle.s20w6(),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Save items you love and come back to them anytime.',
              style: AppTextStyle.s14w4(color: AppPallete.subTextColor),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              buttonName: 'Shop now',

              onPressed: () => Get.offAllNamed(RoutesName.home),
            ),
          ],
        ),
      ),
    );
  }
}
