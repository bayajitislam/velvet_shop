import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';

// ─────────────────────────────────────────────────────────
//  ProductBottomCta  — with cart-drop animation
//
//  Animation sequence on "Add to Cart" tap:
//  1. Button text fades out
//  2. Mini product image appears on button
//  3. Image flies arc path → lands on cart icon position
//  4. Cart icon bounces (shake)
//  5. ✓ "Added" text fades in
//  6. After 1.8s → resets back to "Add to Cart"
//
//  Usage: pass [productImageUrl] so the flying widget
//  matches the product being added.
// ─────────────────────────────────────────────────────────

enum _CartBtnState { idle, flying, added }

class ProductBottomCta extends StatefulWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final String productImageUrl; // for flying mini image

  const ProductBottomCta({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.productImageUrl,
  });

  @override
  State<ProductBottomCta> createState() => _ProductBottomCtaState();
}

class _ProductBottomCtaState extends State<ProductBottomCta>
    with TickerProviderStateMixin {
  _CartBtnState _btnState = _CartBtnState.idle;

  // ── Button text fade ─────────────────────────────────
  late final AnimationController _textFadeCtrl;
  late final Animation<double> _textFade;

  // ── Flying image arc ─────────────────────────────────
  late final AnimationController _flyCtrl;
  late final Animation<double> _flyProgress; // 0→1 along arc
  late final Animation<double> _flyScale; // shrinks as it lands
  late final Animation<double> _flyOpacity;

  // ── Cart icon shake ──────────────────────────────────
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeOffset;

  // ── "Added" text fade-in ─────────────────────────────
  late final AnimationController _addedCtrl;
  late final Animation<double> _addedFade;

  // Global keys to get button & cart icon positions on screen
  final GlobalKey _cartBtnKey = GlobalKey();
  final GlobalKey _cartIconKey = GlobalKey();

  // Computed arc positions (filled once layout is done)
  Offset _flyStart = Offset.zero;
  Offset _flyEnd = Offset.zero;
  bool _showFlyWidget = false;

  @override
  void initState() {
    super.initState();

    // Text fade out
    _textFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _textFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _textFadeCtrl, curve: Curves.easeIn));

    // Flying arc — 700ms
    _flyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _flyProgress = CurvedAnimation(parent: _flyCtrl, curve: Curves.easeInOut);
    _flyScale = Tween<double>(
      begin: 1.0,
      end: 0.15,
    ).animate(CurvedAnimation(parent: _flyCtrl, curve: Curves.easeIn));
    _flyOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _flyCtrl,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // Cart shake
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    // "Added" fade
    _addedCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _addedFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _addedCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _textFadeCtrl.dispose();
    _flyCtrl.dispose();
    _shakeCtrl.dispose();
    _addedCtrl.dispose();
    super.dispose();
  }

  // ── Compute start/end positions for arc ─────────────
  void _computePositions() {
    final btnBox = _cartBtnKey.currentContext?.findRenderObject() as RenderBox?;
    final iconBox =
        _cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (btnBox == null || iconBox == null) return;

    // Start = center of Add to Cart button
    final btnPos = btnBox.localToGlobal(Offset.zero);
    final btnSize = btnBox.size;
    _flyStart = Offset(
      btnPos.dx + btnSize.width / 2,
      btnPos.dy + btnSize.height / 2,
    );

    // End = center of cart icon (Buy Now button left-ish area)
    // We target the cart icon on the Buy Now button
    final iconPos = iconBox.localToGlobal(Offset.zero);
    final iconSize = iconBox.size;
    _flyEnd = Offset(
      iconPos.dx + iconSize.width / 2,
      iconPos.dy + iconSize.height / 2,
    );
  }

  // ── Arc interpolation ────────────────────────────────
  // Quadratic bezier: P = (1-t)²·P0 + 2(1-t)t·P1 + t²·P2
  // Control point is above and between start/end → arc upward
  Offset _arcPosition(double t) {
    final ctrl = Offset(
      (_flyStart.dx + _flyEnd.dx) / 2,
      _flyStart.dy - 120, // arc height
    );
    final mt = 1 - t;
    return Offset(
      mt * mt * _flyStart.dx + 2 * mt * t * ctrl.dx + t * t * _flyEnd.dx,
      mt * mt * _flyStart.dy + 2 * mt * t * ctrl.dy + t * t * _flyEnd.dy,
    );
  }

  // ── Full animation sequence ──────────────────────────
  Future<void> _handleAddToCart() async {
    if (_btnState != _CartBtnState.idle) return;

    _computePositions();
    widget.onAddToCart(); // call parent callback

    // 1. Fade out button text
    await _textFadeCtrl.forward();

    // 2. Show flying widget + start arc
    setState(() {
      _btnState = _CartBtnState.flying;
      _showFlyWidget = true;
    });
    await _flyCtrl.forward();

    // 3. Hide flying widget, shake cart icon
    setState(() => _showFlyWidget = false);
    _shakeCtrl.forward(from: 0);

    // 4. Show "Added" text
    setState(() => _btnState = _CartBtnState.added);
    await _addedCtrl.forward();

    // 5. Wait, then reset
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    await _addedCtrl.reverse();
    await _textFadeCtrl.reverse();
    setState(() => _btnState = _CartBtnState.idle);
    _flyCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── CTA bar ──────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding + 14),
          decoration: BoxDecoration(
            color: AppPallete.surface,
            border: Border(top: BorderSide(color: AppPallete.stroke, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Add to Cart button ──────────────────
              Expanded(
                child: SizedBox(
                  key: _cartBtnKey,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _handleAddToCart,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppPallete.surface,
                      side: BorderSide(
                        color: _btnState == _CartBtnState.added
                            ? AppPallete.primary
                            : AppPallete.border,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _buildCartBtnChild(),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Buy Now button ──────────────────────
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: widget.onBuyNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.bodyText,
                      foregroundColor: AppPallete.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    // Cart icon with shake animation
                    child: AnimatedBuilder(
                      animation: _shakeOffset,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(_shakeOffset.value, 0),
                        child: child,
                      ),
                      child: Row(
                        key: _cartIconKey,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: AppPallete.white,
                          ),
                          const SizedBox(width: 6),
                          Text('Buy Now', style: AppTextStyle.button()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Flying mini image (overlays everything) ──────
        if (_showFlyWidget)
          AnimatedBuilder(
            animation: _flyCtrl,
            builder: (_, _) {
              final pos = _arcPosition(_flyProgress.value);
              final scale = _flyScale.value;
              final opacity = _flyOpacity.value;

              return Positioned(
                // Convert global → local Stack position
                left: pos.dx - 28 * scale,
                top:
                    pos.dy -
                    28 * scale -
                    MediaQuery.of(context).size.height +
                    MediaQuery.of(context).padding.bottom +
                    80,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPallete.primary,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppPallete.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        widget.productImageUrl,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // ── Cart button child based on state ──────────────────
  Widget _buildCartBtnChild() {
    switch (_btnState) {
      case _CartBtnState.idle:
        return FadeTransition(
          key: const ValueKey('idle'),
          opacity: _textFade,
          child: Text(
            'Add to Cart',
            style: AppTextStyle.button(color: AppPallete.bodyText),
          ),
        );

      case _CartBtnState.flying:
        return FadeTransition(
          key: const ValueKey('flying'),
          opacity: _flyProgress, // fades in while flying
          child: Icon(
            Icons.shopping_bag_outlined,
            key: const ValueKey('bag'),
            color: AppPallete.primary,
            size: 22,
          ),
        );

      case _CartBtnState.added:
        return FadeTransition(
          key: const ValueKey('added'),
          opacity: _addedFade,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppPallete.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Added!',
                style: AppTextStyle.button(color: AppPallete.primary),
              ),
            ],
          ),
        );
    }
  }
}
