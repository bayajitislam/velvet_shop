import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/routes/routes_name.dart';

// ─────────────────────────────────────────────────────────
//  OrderSuccessPage — UI only
//
//  Animations:
//  1. Check circle scale + bounce in
//  2. Confetti-like dots burst
//  3. Text + buttons slide up + fade in
// ─────────────────────────────────────────────────────────

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with TickerProviderStateMixin {
  // Check icon bounce
  late final AnimationController _checkCtrl;
  late final Animation<double> _checkScale;

  // Ripple ring
  late final AnimationController _rippleCtrl;
  late final Animation<double> _rippleScale;
  late final Animation<double> _rippleOpacity;

  // Content slide up
  late final AnimationController _contentCtrl;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;

  // Dummy order number
  final String _orderNumber =
      '#VLV${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  @override
  void initState() {
    super.initState();

    // Check bounce
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _checkCtrl, curve: Curves.easeOut));

    // Ripple
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _rippleScale = Tween<double>(
      begin: 0.8,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));
    _rippleOpacity = Tween<double>(
      begin: 0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));

    // Content
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic),
        );
    _contentFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _checkCtrl.forward();
    _rippleCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _contentCtrl.forward();

    // Ripple repeats a few times
    _rippleCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rippleCtrl.reset();
        _rippleCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _rippleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppPallete.scaffold,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 24),
          child: Column(
            children: [
              const Spacer(),

              // ── Success icon with ripple ────────────────
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple ring
                    AnimatedBuilder(
                      animation: _rippleCtrl,
                      builder: (_, __) => Transform.scale(
                        scale: _rippleScale.value,
                        child: Opacity(
                          opacity: _rippleOpacity.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppPallete.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Background circle
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPallete.primary.withValues(alpha: 0.08),
                      ),
                    ),

                    // Check icon
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.primary,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppPallete.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // ── Content ─────────────────────────────────
              SlideTransition(
                position: _contentSlide,
                child: FadeTransition(
                  opacity: _contentFade,
                  child: Column(
                    children: [
                      Text(
                        'Order Placed!',
                        style: AppTextStyle.s32w7(color: AppPallete.bodyText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your order has been placed successfully.\nWe\'ll notify you when it\'s shipped.',
                        style: AppTextStyle.s14w4(
                          color: AppPallete.subTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      // Order number card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppPallete.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppPallete.stroke),
                          boxShadow: [
                            BoxShadow(
                              color: AppPallete.primary.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Order Number',
                              style: AppTextStyle.s12w4(
                                color: AppPallete.subTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _orderNumber,
                              style: AppTextStyle.s20w6(
                                color: AppPallete.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(color: AppPallete.stroke, height: 1),
                            const SizedBox(height: 12),
                            // Estimated delivery
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _InfoChip(
                                  icon: Icons.local_shipping_outlined,
                                  label: 'Est. Delivery',
                                  value: '3–5 days',
                                ),
                                Container(
                                  width: 1,
                                  height: 32,
                                  color: AppPallete.stroke,
                                ),
                                _InfoChip(
                                  icon: Icons.payments_outlined,
                                  label: 'Payment',
                                  value: 'Confirmed',
                                  valueColor: AppPallete.success,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ── Buttons ──────────────────────────────────
              SlideTransition(
                position: _contentSlide,
                child: FadeTransition(
                  opacity: _contentFade,
                  child: Column(
                    children: [
                      // Track order
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(RoutesName.orders),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.bodyText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Track Order',
                            style: AppTextStyle.button(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Continue shopping
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Get.offAllNamed(RoutesName.home),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppPallete.border,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: AppTextStyle.button(
                              color: AppPallete.bodyText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Info Chip
// ─────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppPallete.primary, size: 20),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyle.s10w4(color: AppPallete.subTextColor)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyle.s12w5(color: valueColor ?? AppPallete.bodyText),
        ),
      ],
    );
  }
}
