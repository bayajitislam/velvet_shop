import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  static const _items = [
    (icon: Icons.home_sharp, activeIcon: Icons.home_rounded, label: 'Home'),
    (
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Wishlist',
    ),
    (
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'Cart',
    ),
    (
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive horizontal margin: 8% of screen width, clamped between 16–60
    final horizontalMargin = (screenWidth * 0.08).clamp(16.0, 60.0);

    // Responsive icon size: scales with screen, clamped between 18–24
    final iconSize = (screenWidth * 0.055).clamp(18.0, 24.0);

    // Responsive padding inside icon bubble
    final iconPadding = (screenWidth * 0.03).clamp(10.0, 15.0);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppPallete.bodyText,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final selected = i == c.selectedNavIndex.value;
            return GestureDetector(
              onTap: () => c.onNavItemTapped(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  // Only highlight the selected item
                  color: selected
                      ? AppPallete.white.withValues(alpha: 0.15)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selected ? _items[i].activeIcon : _items[i].icon,
                  color: selected ? AppPallete.white : AppPallete.extraAsh,
                  size: iconSize,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
