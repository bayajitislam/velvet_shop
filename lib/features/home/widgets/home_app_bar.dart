import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/home/controllers/home_controller.dart';
import 'package:velvet/routes/routes_name.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppPallete.primaryLight, width: 2),
            ),
            child: ClipOval(
              child: Obx(
                () => c.isLoggedIn
                    ? Image.network(
                        'https://bayajitislam.com/bayajitislam.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _guestIcon(),
                      )
                    : _guestIcon(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting + name / sign-in
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.homeGreeting,
                  style: AppTextStyle.s12w4(color: AppPallete.subTextColor),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => c.isLoggedIn
                      ? Text(c.userName, style: AppTextStyle.s16w6())
                      : _SignInPill(),
                ),
              ],
            ),
          ),

          // Notification
          _AppBarIconBtn(icon: Icons.notifications_none_rounded, onTap: () {}),
          const SizedBox(width: 10),

          // Cart
          _AppBarIconBtn(
            icon: Icons.shopping_cart_outlined,
            onTap: c.onCartTap,
          ),
        ],
      ),
    );
  }

  Widget _guestIcon() => Container(
    color: AppPallete.background,
    child: const Icon(Icons.person_outline, color: AppPallete.primary),
  );
}

class _SignInPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RoutesName.login),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: AppPallete.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Sign In',
          style: AppTextStyle.s12w5(color: AppPallete.white),
        ),
      ),
    );
  }
}

class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppPallete.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppPallete.bodyText.withValues(alpha: 0.7),
          size: 20,
        ),
      ),
    );
  }
}
