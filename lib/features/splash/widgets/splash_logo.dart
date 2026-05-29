import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, required this.shimmerAnim});

  final Animation<double> shimmerAnim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerAnim,
      builder: (context, child) {
        return Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: AppPallete.transparent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppPallete.primaryDark.withValues(alpha: 0.35),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              children: [
                // Icon
                Center(child: Image.asset('assets/playstore.png')),

                // Shimmer sweep
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(110 * shimmerAnim.value, 0),
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppPallete.white.withValues(alpha: 0.0),
                            AppPallete.white.withValues(alpha: 0.45),
                            AppPallete.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
