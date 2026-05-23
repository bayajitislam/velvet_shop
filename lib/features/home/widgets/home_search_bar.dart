import 'package:flutter/material.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  const HomeSearchBar({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppPallete.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppPallete.dropShadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppStrings.homeSearchHint,
                  hintStyle: AppTextStyle.s14w4(),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppPallete.extraAsh, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppPallete.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppPallete.dropShadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.tune_rounded,
                  color: AppPallete.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}