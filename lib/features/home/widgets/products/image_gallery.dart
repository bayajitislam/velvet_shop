import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

// ─────────────────────────────────────────────────────────
//  ImageGallery
//
//  • BoxFit.cover with Alignment(0, -0.3) — subject sits
//    between top and center, never gets cropped awkwardly
//  • Hero tag: 'product-image-${images[0]}' — wire same tag
//    on the ProductCard for smooth list→detail transition
//  • Active thumbnail grows + full opacity, inactive shrinks + dimmed
// ─────────────────────────────────────────────────────────

class ImageGallery extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ImageGallery({
    super.key,
    required this.images,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPallete.background,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // ── Main paged images ──────────────────────────
          PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: images.length,
            itemBuilder: (_, i) {
              final isFirst = i == 0;
              return Hero(
                tag: isFirst
                    ? 'product-image-${images[0]}'
                    : 'product-image-$i',
                child: Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  // KEY FIX: y=-0.3 → 30% above center
                  // subject (face/torso) always visible
                  alignment: const Alignment(0, -0.3),
                  width: double.infinity,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppPallete.background,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                          color: AppPallete.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: AppPallete.background,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppPallete.extraAsh,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Thumbnail strip — right side ───────────────
          if (images.length > 1)
            Positioned(
              right: 10,
              top: 12,
              child: Column(
                children: List.generate(images.length, (i) {
                  final active = i == currentIndex;
                  return GestureDetector(
                    onTap: () => controller.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.only(bottom: 8),
                      width: active ? 58 : 52,
                      height: active ? 74 : 66,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active
                              ? AppPallete.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                active ? 0.22 : 0.10),
                            blurRadius: active ? 10 : 5,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: active ? 1.0 : 0.65,
                        child: Image.network(
                          images[i],
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.3),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

          // ── Bottom gradient ────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0, height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Dot indicators ─────────────────────────────
          Positioned(
            bottom: 12,
            left: 14,
            child: Row(
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 5),
                  width: i == currentIndex ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == currentIndex
                        ? AppPallete.white
                        : AppPallete.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}