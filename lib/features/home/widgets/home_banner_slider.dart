import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/core/utils/screen_size.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';
import 'package:velvet/features/home/models/bennar_model.dart';

// ─────────────────────────────────────────────────────────
//  HomeBannerSlider
//
//  • Full-bleed background image (BoxFit.cover)
//  • Left-side gradient overlay → text readable on any image
//  • Title + subtitle + Shop Now button on left foreground
//  • Fully responsive via ScreenSize extension (375px baseline)
//  • Auto-play page controller (wire in HomeController)
//  • Skeleton while loading
// ─────────────────────────────────────────────────────────

class HomeBannerSlider extends StatelessWidget {
  const HomeBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    // Responsive banner height — 48% of screen width keeps
    // aspect ratio consistent across phone sizes
    final bannerHeight = context.widthPercentage(48);

    return Obx(() {
      if (c.isBannerLoading.value) {
        return _BannerSkeleton(height: bannerHeight);
      }

      return Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: PageView.builder(
              controller: c.bannerPageController,
              onPageChanged: c.onBannerPageChanged,
              itemCount: c.banners.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing16),
                child: _BannerCard(banner: c.banners[i]),
              ),
            ),
          ),

          SizedBox(height: context.spacing8),

          // Dot indicators
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

// ─────────────────────────────────────────────────────────
//  Banner Card — full bleed image + left gradient + text
// ─────────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    // Responsive values
    final titleSize = context.responsiveFontSize(18);
    final subtitleSize = context.responsiveFontSize(11);
    final btnFontSize = context.responsiveFontSize(11);
    final hPad = context.spacing16;
    final vPad = context.spacing16;

    return Container(
      decoration: BoxDecoration(
        color: banner.bgColor, // fallback bg while image loads
        borderRadius: BorderRadius.circular(context.responsiveSize(12)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Full-bleed background image ─────────────
          Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
            // Bias slightly to the right so subject stays visible
            alignment: const Alignment(0.4, 0.0),
            errorBuilder: (_, _, _) => Container(color: banner.bgColor),
          ),

          // ── 2. Decorative subtle circle (top-right) ─────
          Positioned(
            right: -context.responsiveSize(24),
            top: -context.responsiveSize(24),
            child: Container(
              width: context.responsiveSize(110),
              height: context.responsiveSize(110),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // ── 3. Text + button (left foreground) ──────────
          Positioned(
            left: hPad,
            top: vPad,
            bottom: vPad,
            // Limit text area to ~55% width so it never overlaps face
            right: context.widthPercentage(42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  banner.title,
                  style: AppTextStyle.s20w6(
                    color: AppPallete.white,
                    fontSize: titleSize,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: context.spacing8),

                // Subtitle
                Text(
                  banner.subtitle,
                  style: AppTextStyle.s12w4(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: subtitleSize,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: context.spacing16),

                // Shop Now button
                _ShopNowBtn(fontSize: btnFontSize),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Shop Now Button
// ─────────────────────────────────────────────────────────

class _ShopNowBtn extends StatelessWidget {
  final double fontSize;
  const _ShopNowBtn({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppPallete.white,
        borderRadius: BorderRadius.circular(context.responsiveSize(20)),
      ),
      child: Text(
        AppStrings.homeBtnShopNow,
        style: AppTextStyle.s12w5(color: AppPallete.black, fontSize: fontSize),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Skeleton loader
// ─────────────────────────────────────────────────────────

class _BannerSkeleton extends StatefulWidget {
  final double height;
  const _BannerSkeleton({required this.height});

  @override
  State<_BannerSkeleton> createState() => _BannerSkeletonState();
}

class _BannerSkeletonState extends State<_BannerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmer = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: AnimatedBuilder(
        animation: _shimmer,
        builder: (_, _) {
          return Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.responsiveSize(20)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (_shimmer.value - 0.3).clamp(0.0, 1.0),
                  (_shimmer.value).clamp(0.0, 1.0),
                  (_shimmer.value + 0.3).clamp(0.0, 1.0),
                ],
                colors: [
                  AppPallete.background,
                  AppPallete.stroke,
                  AppPallete.background,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
