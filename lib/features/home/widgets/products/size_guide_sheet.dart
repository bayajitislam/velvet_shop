import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class SizeGuideSheet extends StatelessWidget {
  const SizeGuideSheet({super.key});

  static const _sizes = [
    ['XS', '32–34"', '24–26"', '34–36"'],
    ['S',  '34–36"', '26–28"', '36–38"'],
    ['M',  '36–38"', '28–30"', '38–40"'],
    ['L',  '38–40"', '30–32"', '40–42"'],
    ['XL', '40–42"', '32–34"', '42–44"'],
    ['XXL','42–44"', '34–36"', '44–46"'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppPallete.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          Text('Size Guide', style: AppTextStyle.s20w6()),

          const SizedBox(height: 16),

          Table(
            border: TableBorder.all(
              color: AppPallete.border,
              width: 0.5,
            ),
            children: [
              // Header row
              TableRow(
                decoration: const BoxDecoration(color: AppPallete.background),
                children: ['Size', 'Chest', 'Waist', 'Hip'].map((h) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      h,
                      style: AppTextStyle.s12w5(color: AppPallete.primary),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
              // Data rows
              ..._sizes.map(
                (row) => TableRow(
                  children: row
                      .map(
                        (cell) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            cell,
                            style: AppTextStyle.s12w4(
                              color: AppPallete.bodyText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Got it', style: AppTextStyle.button()),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}