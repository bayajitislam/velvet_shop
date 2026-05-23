import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class SplashBackgroundDecor extends StatelessWidget {
  const SplashBackgroundDecor({
    super.key,
    required this.size,
    required this.scaleAnim,
  });

  final Size size;
  final Animation<double> scaleAnim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left accent circle
        Positioned(
          top: -size.width * 0.25,
          left: -size.width * 0.25,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.primaryDark.withValues(alpha: 0.35),
              ),
            ),
          ),
        ),

        // Bottom-right accent circle
        Positioned(
          bottom: -size.width * 0.3,
          right: -size.width * 0.2,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.primaryDark.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),

        // Small top-right dot
        Positioned(
          top: size.height * 0.15,
          right: 32,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.white,
              ),
            ),
          ),
        ),

        // Small bottom-left dot
        Positioned(
          bottom: size.height * 0.18,
          left: 28,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
