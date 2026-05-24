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
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppPallete.bodyText,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final selected = i == c.selectedNavIndex.value;
            return GestureDetector(
              onTap: () => c.onNavItemTapped(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 56,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppPallete.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      selected ? _items[i].activeIcon : _items[i].icon,
                      color: selected ? AppPallete.white : AppPallete.extraAsh,
                      size: 22,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
