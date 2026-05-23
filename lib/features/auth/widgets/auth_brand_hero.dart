import 'package:flutter/material.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class AuthBrandHero extends StatelessWidget {
  const AuthBrandHero({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppPallete.primary,
      padding: EdgeInsets.only(top: topPad + 32, bottom: 36),
      child: Center(
        child: Column(
          children: [
            // Logo with soft glow
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppPallete.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppPallete.dropShadow,
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: AppPallete.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: AppTextStyle.s32w7(color: AppPallete.white),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.loginTitle,
              style: AppTextStyle.s12w4(color: AppPallete.white),
            ),
          ],
        ),
      ),
    );
  }
}
