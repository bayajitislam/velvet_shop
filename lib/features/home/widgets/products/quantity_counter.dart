import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class QuantityCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // + button — filled dark circle
        _CounterBtn(icon: Icons.add, filled: true, onTap: onIncrement),

        const SizedBox(height: 6),

        // Quantity number
        Text(
          quantity.toString().padLeft(2, '0'),
          style: AppTextStyle.s14w6(color: AppPallete.bodyText),
        ),

        const SizedBox(height: 6),

        // − button — outlined circle
        _CounterBtn(icon: Icons.remove, filled: false, onTap: onDecrement),
      ],
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _CounterBtn({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled ? AppPallete.bodyText : AppPallete.surface,
          shape: BoxShape.circle,
          border: filled
              ? null
              : Border.all(color: AppPallete.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppPallete.dropShadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: filled ? AppPallete.white : AppPallete.bodyText,
          size: 16,
        ),
      ),
    );
  }
}