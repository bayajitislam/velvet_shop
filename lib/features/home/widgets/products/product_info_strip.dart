import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class ProductInfoStrip extends StatelessWidget {
  const ProductInfoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _InfoItem(
            icon: Icons.local_shipping_outlined,
            label: 'Free Delivery',
          ),
          _VerticalDivider(),
          _InfoItem(
            icon: Icons.replay_outlined,
            label: '30-Day Returns',
          ),
          _VerticalDivider(),
          _InfoItem(
            icon: Icons.verified_outlined,
            label: 'Authentic',
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppPallete.primary, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.s10w4(color: AppPallete.subTextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppPallete.border);
  }
}