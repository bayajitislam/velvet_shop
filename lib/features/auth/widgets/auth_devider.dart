import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppPallete.stroke)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: AppTextStyle.s12w4()),
        ),
        const Expanded(child: Divider(color: AppPallete.stroke)),
      ],
    );
  }
}
