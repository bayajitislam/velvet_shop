import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';
import 'package:velvet/features/home/models/bennar_model.dart';

class HomeBannerSlider extends StatelessWidget {
  const HomeBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Obx(() {
      if (c.isBannerLoading.value) {
        return const _BannerSkeleton();
      }
      return Column(
        children: [
          SizedBox(
            height: 185,
            child: PageView.builder(
              controller: c.bannerPageController,
              onPageChanged: c.onBannerPageChanged,
              itemCount: c.banners.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BannerCard(banner: c.banners[i]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                c.banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == c.currentBannerIndex.value ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == c.currentBannerIndex.value
                        ? AppPallete.primary
                        : AppPallete.primaryLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: banner.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Model image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 155,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          // Text
          Positioned(
            left: 20,
            top: 20,
            bottom: 20,
            right: 155,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: AppTextStyle.s20w6(color: AppPallete.white),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: AppTextStyle.s12w4(color: Colors.white70),
                  maxLines: 2,
                ),
                const SizedBox(height: 14),
                _ShopNowBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopNowBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        AppStrings.homeBtnShopNow,
        style: AppTextStyle.s12w5(color: AppPallete.primaryDark),
      ),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: AppPallete.background,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
