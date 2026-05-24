import 'package:flutter/material.dart';
import 'package:velvet/core/theme/app_pallete.dart';

class ZoomableImage extends StatefulWidget {
  final String imageUrl;

  const ZoomableImage({super.key, required this.imageUrl});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _ctrl = TransformationController();

  // ── Reset animation ────────────────────────────────────
  late final AnimationController _resetCtrl;
  Animation<Matrix4>? _resetAnim;

  // ── Double-tap zoom ────────────────────────────────────
  TapDownDetails? _doubleTapDetails;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => _ctrl.value = _resetAnim!.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _resetCtrl.dispose();
    super.dispose();
  }

  // ── Smooth snap back when fingers lift ─────────────────
  void _onInteractionEnd(ScaleEndDetails _) {
    final scale = _ctrl.value.getMaxScaleOnAxis();

    // If scale < 1.2, snap fully back to normal
    if (scale < 1.2) {
      _animateReset();
      return;
    }
    setState(() => _isZoomed = true);
  }

  void _onInteractionStart(ScaleStartDetails _) {
    // Cancel any running reset animation
    if (_resetCtrl.isAnimating) _resetCtrl.stop();
  }

  void _animateReset() {
    _resetAnim = Matrix4Tween(
      begin: _ctrl.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOutCubic));
    _resetCtrl.forward(from: 0);
    setState(() => _isZoomed = false);
  }

  // ── Double tap — toggle 2.5× zoom at tap position ──────
  void _onDoubleTap() {
    if (_isZoomed) {
      _animateReset();
      return;
    }

    final pos = _doubleTapDetails!.localPosition;
    final x = -pos.dx * 1.5;
    final y = -pos.dy * 1.5;

    final zoomed = Matrix4.identity()
      ..translate(x, y)
      ..scale(2.5);

    _resetAnim = Matrix4Tween(
      begin: _ctrl.value,
      end: zoomed,
    ).animate(CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOutCubic));
    _resetCtrl.forward(from: 0);
    setState(() => _isZoomed = true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Capture double-tap position before it fires
      onDoubleTapDown: (d) => _doubleTapDetails = d,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _ctrl,
        minScale: 1.0,
        maxScale: 5.0,
        // pan only when zoomed — lets PageView swipe work normally
        panEnabled: _isZoomed,
        clipBehavior: Clip.none,
        onInteractionStart: _onInteractionStart,
        onInteractionEnd: _onInteractionEnd,
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.3),
          width: double.infinity,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              color: AppPallete.background,
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                      : null,
                  color: AppPallete.primary,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            color: AppPallete.background,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppPallete.extraAsh,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
