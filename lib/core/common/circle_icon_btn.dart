import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? bgColor;

  const CircleIconBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor ?? AppPallete.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? AppPallete.bodyText, size: 18),
      ),
    );
  }
}
