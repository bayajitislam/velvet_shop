import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

class AuthSocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const AuthSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppPallete.border, width: 1.5),
        backgroundColor: AppPallete.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppPallete.bodyText, size: 20),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyle.s14w6(color: AppPallete.bodyText)),
        ],
      ),
    );
  }
}
