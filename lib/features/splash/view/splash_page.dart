import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velvet/core/constants/app_strings.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/splash/controllers/splash_controller.dart';
import 'package:velvet/features/splash/widgets/splash_background_decor.dart';
import 'package:velvet/features/splash/widgets/splash_logo.dart';
import 'package:velvet/features/splash/widgets/splash_pulsing_dots.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // ── Controller (business logic + navigation) ───────────────────────────────
  late final SplashController _ctrl;

  // ── Animation Controllers ──────────────────────────────────────────────────
  late final AnimationController _bgCircleController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;
  late final AnimationController _shimmerController;

  // ── Animations ─────────────────────────────────────────────────────────────
  late final Animation<double> _bgCircleScale;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    // Register controller (if not already — e.g. from main binding)
    _ctrl = Get.put(SplashController());

    // Immersive splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // ── Background circle ──────────────────────────────────────────────────
    _bgCircleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _bgCircleScale = CurvedAnimation(
      parent: _bgCircleController,
      curve: Curves.easeOutExpo,
    );

    // ── Logo pop-in ────────────────────────────────────────────────────────
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // ── Brand name slide-up ────────────────────────────────────────────────
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // ── Tagline fade-in ────────────────────────────────────────────────────
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    // ── Shimmer ────────────────────────────────────────────────────────────
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 1. Background expands
    await _bgCircleController.forward();

    // 2. Logo pops in
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();

    // 3. Brand name slides up
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();

    // 4. Tagline fades
    await Future.delayed(const Duration(milliseconds: 250));
    _taglineController.forward();

    // 5. Shimmer plays
    await Future.delayed(const Duration(milliseconds: 200));
    _shimmerController.forward();

    // 6. Hold, restore UI, then let the controller decide where to go
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // ↓ Controller checks token and routes accordingly
      _ctrl.navigateAfterSplash();
    }
  }

  @override
  void dispose() {
    _bgCircleController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppPallete.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative background circles
          SplashBackgroundDecor(size: size, scaleAnim: _bgCircleScale),

          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: SplashLogo(shimmerAnim: _shimmerAnim),
                ),
              ),
              const SizedBox(height: 24),
              ClipRect(
                child: SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Text(
                      AppStrings.appName,
                      style: AppTextStyle.s32w7(
                        color: AppPallete.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _taglineOpacity,
                child: Text(
                  AppStrings.discoverYourSignatureLook,
                  style: AppTextStyle.s14w4(
                    color: AppPallete.white.withValues(alpha: 0.80),
                  ),
                ),
              ),
            ],
          ),

          // Bottom pulsing dots
          Positioned(
            bottom: 60,
            child: FadeTransition(
              opacity: _taglineOpacity,
              child: const SplashPulsingDots(),
            ),
          ),
        ],
      ),
    );
  }
}