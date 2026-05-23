import 'package:flutter/material.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class AuthSignupHeader extends StatelessWidget {
  const AuthSignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppPallete.primary,
      padding: EdgeInsets.only(
        top: topPad + 10,
        bottom: 24,
        left: 8,
        right: 16,
      ),
      child: Row(
        children: [
          // Back Button with soft tint
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPallete.white30,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppPallete.white,
              ),
            ),
          ),
          const Spacer(),
          Text(
            AppStrings.signupHeaderTitle,
            style: AppTextStyle.s20w6(color: AppPallete.white),
          ),
          const Spacer(),
          const SizedBox(width: 48), // visual balance
        ],
      ),
    );
  }
}