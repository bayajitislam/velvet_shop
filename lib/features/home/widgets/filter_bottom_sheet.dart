import 'package:flutter/material.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Handle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.filterTitle,
                  style: AppTextStyle.s20w6(),
                ),
                Text(
                  AppStrings.filterReset,
                  style: AppTextStyle.s14w6(color: AppPallete.primary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppPallete.stroke),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterSection(
                  title: AppStrings.filterCategory,
                  child: Wrap(
                    spacing: 10,
                    children: [
                      _FilterChip(label: 'All', isSelected: true),
                      _FilterChip(label: 'Women'),
                      _FilterChip(label: 'Men'),
                      _FilterChip(label: 'Kids'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _FilterSection(
                  title: AppStrings.filterPriceRange,
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppPallete.primary,
                      inactiveTrackColor: AppPallete.border,
                      thumbColor: AppPallete.primary,
                    ),
                    child: Slider(
                      value: 50,
                      min: 0,
                      max: 100,
                      onChanged: (v) {},
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppStrings.filterApply,
                      style: AppTextStyle.button(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: AppPallete.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.s16w6()),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppPallete.primary : AppPallete.scaffold,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPallete.border),
      ),
      child: Text(
        label,
        style: AppTextStyle.s12w5(
          color: isSelected ? AppPallete.white : AppPallete.bodyText,
        ),
      ),
    );
  }
}