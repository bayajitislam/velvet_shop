import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/core/widgets/primary_button.dart';
import 'package:velvet/features/cart/controllers/cart_controller.dart';
import 'package:velvet/features/cart/models/cart_item_model.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  CartPage
//
//  • Swipe left to delete item (Dismissible)
//  • Inline quantity +/-
//  • Order summary at bottom
//  • Empty state
// ─────────────────────────────────────────────────────────

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CartController>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Obx(
          () => Text(
            c.items.isEmpty ? 'Cart' : 'Cart (${c.items.length})',
            style: AppTextStyle.s16w6(),
          ),
        ),
        actions: [
          Obx(
            () => c.items.isNotEmpty
                ? TextButton(
                    onPressed: c.clearCart,
                    child: Text(
                      'Clear',
                      style: AppTextStyle.s12w5(color: AppPallete.primary),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),

      body: Obx(() {
        if (c.items.isEmpty) return const _EmptyCart();

        return Stack(
          children: [
            // ── Cart item list ──────────────────────────
            ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 260 + bottomPadding),
              itemCount: c.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final item = c.items[i];
                return _CartItemTile(
                  item: item,
                  onDismissed: () => c.removeItem(item),
                  onIncrement: () => c.increment(item),
                  onDecrement: () => c.decrement(item),
                );
              },
            ),

            // ── Order summary (pinned bottom) ───────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _OrderSummary(controller: c, bottomPadding: bottomPadding),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Cart Item Tile — swipe to delete
// ─────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onDismissed;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemTile({
    required this.item,
    required this.onDismissed,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart, // swipe left only
      onDismissed: (_) => onDismissed(),

      // ── Red delete background ───────────────────────
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppPallete.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),

      // ── Item card ───────────────────────────────────
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppPallete.primary.withValues(alpha: 0.12),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 90,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.3),
                errorBuilder: (_, _, _) => Container(
                  width: 80,
                  height: 90,
                  color: AppPallete.background,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppPallete.extraAsh,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name, size, price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyle.s14w6(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Size badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppPallete.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Size: ${item.size}',
                      style: AppTextStyle.s10w4(color: AppPallete.bodyText),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyle.s16w6(color: AppPallete.primary),
                  ),
                ],
              ),
            ),

            // Quantity control
            Column(
              children: [
                _QtyBtn(icon: Icons.add, onTap: onIncrement, filled: true),
                const SizedBox(height: 6),
                Text(
                  item.quantity.toString().padLeft(2, '0'),
                  style: AppTextStyle.s14w6(),
                ),
                const SizedBox(height: 6),
                _QtyBtn(icon: Icons.remove, onTap: onDecrement, filled: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quantity button ────────────────────────────────────────
class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyBtn({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? AppPallete.bodyText : AppPallete.surface,
          shape: BoxShape.circle,
          border: filled
              ? null
              : Border.all(color: AppPallete.border, width: 1.2),
        ),
        child: Icon(
          icon,
          size: 15,
          color: filled ? AppPallete.white : AppPallete.bodyText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Order Summary
// ─────────────────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  final CartController controller;
  final double bottomPadding;

  const _OrderSummary({required this.controller, required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding + 20),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppPallete.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Subtotal
          Obx(
            () => _SummaryRow(
              label: 'Subtotal',
              value: '\$${controller.subtotal.toStringAsFixed(2)}',
            ),
          ),
          const SizedBox(height: 8),

          // Delivery
          _SummaryRow(
            label: 'Delivery',
            value: 'Free',
            valueColor: AppPallete.success,
          ),
          const SizedBox(height: 12),

          Divider(color: AppPallete.stroke, height: 1),
          const SizedBox(height: 12),

          // Total
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyle.s16w6()),
                Text(
                  '\$${controller.subtotal.toStringAsFixed(2)}',
                  style: AppTextStyle.s20w6(color: AppPallete.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Checkout button
          PrimaryButton(
            buttonName: 'Proceed to Checkout',
            onPressed: () {
              // For demo, just clear cart and show snackbar
              controller.clearCart();
              Get.toNamed(RoutesName.checkout);
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.s14w4(color: AppPallete.subTextColor)),
        Text(
          value,
          style: AppTextStyle.s14w6(color: valueColor ?? AppPallete.bodyText),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Empty Cart
// ─────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppPallete.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 44,
                color: AppPallete.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: AppTextStyle.s20w6(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to your cart and they\'ll show up here.',
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
