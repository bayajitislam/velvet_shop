import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.favorite_border_rounded, label: 'Wishlist'),
    (icon: Icons.shopping_cart_outlined, label: 'Cart'),
    (icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Obx(
      () => Container(
        height: 64,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppPallete.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _items[i].icon,
                      color: selected
                          ? AppPallete.white
                          : AppPallete.extraAsh,
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