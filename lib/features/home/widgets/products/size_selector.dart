import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        final selected = size == selectedSize;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => onSelected(size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                // Screenshot: selected = dark (#212121), unselected = white
                color: selected ? AppPallete.bodyText : AppPallete.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppPallete.bodyText
                      : AppPallete.border,
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: AppTextStyle.s12w5(
                    color: selected
                        ? AppPallete.white
                        : AppPallete.subTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}