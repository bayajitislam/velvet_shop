import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class SplashPulsingDots extends StatefulWidget {
  const SplashPulsingDots({super.key});

  @override
  State<SplashPulsingDots> createState() => _SplashPulsingDotsState();
}

class _SplashPulsingDotsState extends State<SplashPulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final delay = i * 0.3;
            final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2)).clamp(
              0.3,
              1.0,
            );
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.white.withValues(alpha: opacity),
              ),
            );
          },
        );
      }),
    );
  }
}
