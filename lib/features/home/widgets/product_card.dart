import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/home/models/product_model.dart';

class ProductCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppPallete.dropShadow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            // ── Left: Product image ──────────────────────
            SizedBox(
              width: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppPallete.background,
                          AppPallete.primaryLight.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                  // Image
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppPallete.extraAsh,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Right: Info ──────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Favorite + category tag row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppPallete.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Fashion',
                            style: AppTextStyle.s10w4(
                              color: AppPallete.primary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: product.isFavorite
                                  ? AppPallete.primary
                                  : AppPallete.background,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: product.isFavorite
                                  ? AppPallete.white
                                  : AppPallete.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Product name
                    Text(
                      product.name,
                      style: AppTextStyle.s16w6(),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      product.subtitle,
                      style: AppTextStyle.s12w4(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Star rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppPallete.star,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating}',
                          style: AppTextStyle.s12w5(color: AppPallete.bodyText),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: AppTextStyle.s10w4(),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyle.s16w6(color: AppPallete.primary),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(0)}',
                            style: AppTextStyle.strikethrough(),
                          ),
                        ],
                        const Spacer(),
                        // Add to cart mini btn
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppPallete.bodyText,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppPallete.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
