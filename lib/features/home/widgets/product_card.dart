import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/home/models/product_model.dart';
import 'package:velvet/features/wishlist/controllers/wishlist_controller.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _imageLoaded = false;

  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _shimmerAnim = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 333,
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppPallete.black.withValues(alpha: 0.18),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // ── 1. Network image ───────────────────────
              Positioned.fill(
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.3),
                  frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && !_imageLoaded) {
                          setState(() => _imageLoaded = true);
                        }
                      });
                      return child;
                    }
                    return const SizedBox.expand();
                  },
                  errorBuilder: (_, __, ___) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && !_imageLoaded) {
                        setState(() => _imageLoaded = true);
                      }
                    });
                    return Container(
                      color: AppPallete.background,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppPallete.extraAsh,
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── 2. Shimmer skeleton ────────────────────
              if (!_imageLoaded)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerAnim,
                    builder: (_, __) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (_shimmerAnim.value - 0.4).clamp(0.0, 1.0),
                              (_shimmerAnim.value).clamp(0.0, 1.0),
                              (_shimmerAnim.value + 0.4).clamp(0.0, 1.0),
                            ],
                            colors: [
                              AppPallete.background,
                              AppPallete.stroke,
                              AppPallete.background,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SkeletonLine(width: 120, height: 14),
                                  const SizedBox(height: 6),
                                  _SkeletonLine(width: 80, height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // ── 3. Wishlist button — reactive ──────────
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: widget.onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    // ✅ reads directly from RxList — guaranteed reactive
                    child: Obx(() {
                      final wishlisted = Get.find<WishlistController>().items
                          .any((p) => p.id == widget.product.id);
                      return Icon(
                        wishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: wishlisted
                            ? AppPallete.primary
                            : AppPallete.white,
                        size: 22,
                      );
                    }),
                  ),
                ),
              ),

              // ── 4. Bottom text ─────────────────────────
              if (_imageLoaded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: AppTextStyle.s20w6(
                                      color: AppPallete.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '\$${widget.product.price.toStringAsFixed(2)}',
                                    style: AppTextStyle.s20w6(
                                      color: AppPallete.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.product.subtitle,
                                style: AppTextStyle.s14w4(
                                  color: AppPallete.white.withValues(
                                    alpha: 0.75,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppPallete.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
