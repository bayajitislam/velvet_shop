import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velvet/core/theme/app_pallete.dart';
import 'package:velvet/core/theme/app_text_style.dart';
import 'package:velvet/features/cart/controllers/cart_controller.dart';
import 'package:velvet/features/cart/models/cart_item_model.dart';
import 'package:velvet/features/home/models/product_model.dart';
import 'package:velvet/features/home/widgets/products/image_gallery.dart';
import 'package:velvet/features/home/widgets/products/quantity_counter.dart';
import 'package:velvet/features/home/widgets/products/size_guide_sheet.dart';
import 'package:velvet/features/home/widgets/products/size_selector.dart';
import 'package:velvet/features/wishlist/controllers/wishlist_controller.dart';
import 'package:velvet/routes/routes_name.dart';

enum _CartBtnState { idle, flying, added }

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late final ProductModel _product;

  // ── Controllers (lazy — safe after initState) ────────
  CartController get _cart => Get.find<CartController>();
  WishlistController get _wishlist => Get.find<WishlistController>();

  int _currentImage = 0;
  String _selectedSize = 'M';
  int _quantity = 1;
  bool _isFavorite = false;
  bool _descExpanded = false;
  _CartBtnState _cartBtnState = _CartBtnState.idle;

  final PageController _imageController = PageController();
  final ScrollController _scrollController = ScrollController();

  // ── Enter animation ──────────────────────────────────
  late final AnimationController _enterCtrl;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;

  // ── Favorite bounce ──────────────────────────────────
  late final AnimationController _favCtrl;
  late final Animation<double> _favScale;

  // ── Cart button text fade ────────────────────────────
  late final AnimationController _btnTextCtrl;
  late final Animation<double> _btnTextFade;

  // ── Cart shake ───────────────────────────────────────
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeOffset;

  // ── Added text ───────────────────────────────────────
  late final AnimationController _addedCtrl;
  late final Animation<double> _addedFade;

  // ── Flying image (Overlay) ───────────────────────────
  late final AnimationController _flyCtrl;
  late final Animation<double> _flyProgress;
  late final Animation<double> _flyScale;
  late final Animation<double> _flyOpacity;
  OverlayEntry? _flyOverlay;

  final GlobalKey _addToCartBtnKey = GlobalKey();
  final GlobalKey _buyNowBtnKey = GlobalKey();

  double _appBarTitleOpacity = 0.0;
  double _parallaxOffset = 0.0;

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const _imageHeight = 320.0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _product = Get.arguments as ProductModel;

    //  Seed heart icon from WishlistController — stays in sync across pages
    _isFavorite = _wishlist.isWishlisted(_product.id);

    // ── Enter ──────────────────────────────────────────
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // ── Favorite bounce ────────────────────────────────
    _favCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _favScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.90), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _favCtrl, curve: Curves.easeOut));

    // ── Button text fade ───────────────────────────────
    _btnTextCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _btnTextFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _btnTextCtrl, curve: Curves.easeIn));

    // ── Shake ──────────────────────────────────────────
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -7.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -7.0, end: 7.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 7.0, end: -5.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    // ── Added fade ─────────────────────────────────────
    _addedCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _addedFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _addedCtrl, curve: Curves.easeOut));

    // ── Flying arc ─────────────────────────────────────
    _flyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _flyProgress = CurvedAnimation(parent: _flyCtrl, curve: Curves.easeInOut);
    _flyScale = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _flyCtrl, curve: Curves.easeIn));
    _flyOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _flyCtrl,
        curve: const Interval(0.70, 1.0, curve: Curves.easeIn),
      ),
    );

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _enterCtrl.forward());
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() => _parallaxOffset = offset * 0.40);
    final opacity = ((offset - (_imageHeight - 60)) / 70).clamp(0.0, 1.0);
    if (opacity != _appBarTitleOpacity) {
      setState(() => _appBarTitleOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _flyOverlay?.remove();
    _imageController.dispose();
    _scrollController.dispose();
    _enterCtrl.dispose();
    _favCtrl.dispose();
    _btnTextCtrl.dispose();
    _shakeCtrl.dispose();
    _addedCtrl.dispose();
    _flyCtrl.dispose();
    super.dispose();
  }

  // ── Arc math (quadratic bezier) ──────────────────────
  Offset _arcPosition(Offset start, Offset end, double t) {
    final ctrl = Offset((start.dx + end.dx) / 2, start.dy - 160);
    final mt = 1 - t;
    return Offset(
      mt * mt * start.dx + 2 * mt * t * ctrl.dx + t * t * end.dx,
      mt * mt * start.dy + 2 * mt * t * ctrl.dy + t * t * end.dy,
    );
  }

  Offset? _globalCenter(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final pos = box.localToGlobal(Offset.zero);
    return pos + Offset(box.size.width / 2, box.size.height / 2);
  }

  // ── Build CartItemModel from current page state ──────
  CartItemModel _buildCartItem() => CartItemModel.fromProduct(
    productId: _product.id,
    name: _product.name,
    subtitle: _product.subtitle, // swap if your field is named differently
    imageUrl: _product.images.first,
    size: _selectedSize,
    price: _product.price,
    quantity: _quantity,
  );

  // ── Add to Cart — animation + actual cart call ───────
  Future<void> _handleAddToCart() async {
    if (_cartBtnState != _CartBtnState.idle) return;

    final start = _globalCenter(_addToCartBtnKey);
    final end = _globalCenter(_buyNowBtnKey);
    if (start == null || end == null) return;

    //  Add to CartController first
    _cart.addItem(_buildCartItem());

    // 1. Fade out button text
    await _btnTextCtrl.forward();
    setState(() => _cartBtnState = _CartBtnState.flying);

    // 2. Launch flying overlay
    _flyCtrl.reset();
    _flyOverlay = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _flyCtrl,
        builder: (_, _) {
          final pos = _arcPosition(start, end, _flyProgress.value);
          final scale = _flyScale.value.clamp(0.0, 1.0);
          final opacity = _flyOpacity.value.clamp(0.0, 1.0);
          final size = 52.0 * scale;

          return Positioned(
            left: pos.dx - size / 2,
            top: pos.dy - size / 2,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: size.clamp(4.0, 52.0),
                height: size.clamp(4.0, 52.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppPallete.primary,
                    width: (2.5 * scale).clamp(0.5, 2.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppPallete.primary.withValues(
                        alpha: 0.4 * opacity,
                      ),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  _product.images.first,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.3),
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_flyOverlay!);
    await _flyCtrl.forward();

    // 3. Remove overlay + shake Buy Now button
    _flyOverlay?.remove();
    _flyOverlay = null;
    _shakeCtrl.forward(from: 0);

    // 4. Show "Added!"
    setState(() => _cartBtnState = _CartBtnState.added);
    await _addedCtrl.forward();

    // 5. Hold then reset
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    await _addedCtrl.reverse();
    await _btnTextCtrl.reverse();
    setState(() => _cartBtnState = _CartBtnState.idle);
  }

  // ── Buy Now — add to cart silently then go to cart ───
  void _handleBuyNow() {
    _cart.addItem(_buildCartItem());
    Get.toNamed(RoutesName.cart);
  }

  // ── Wishlist — delegates to WishlistController ───────
  void _toggleFavorite() {
    _wishlist.toggle(_product);
    setState(() => _isFavorite = _wishlist.isWishlisted(_product.id));
    _favCtrl.forward(from: 0);
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SizeGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.scaffold,

      appBar: AppBar(
        backgroundColor: AppPallete.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _AppBarIconBtn(
            icon: Icons.chevron_left_rounded,
            onTap: () => Get.back(),
          ),
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _appBarTitleOpacity,
          child: Text(
            'Product Details',
            style: AppTextStyle.s16w6().copyWith(color: AppPallete.bodyText),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ScaleTransition(
              scale: _favScale,
              child: _AppBarIconBtn(
                icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                iconColor: _isFavorite
                    ? AppPallete.primary
                    : AppPallete.bodyText,
                onTap: _toggleFavorite,
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── Parallax image ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: _imageHeight,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -_parallaxOffset,
                            left: 0,
                            right: 0,
                            height: _imageHeight + 80,
                            child: ImageGallery(
                              images: _product.images,
                              controller: _imageController,
                              currentIndex: _currentImage,
                              onPageChanged: (i) =>
                                  setState(() => _currentImage = i),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Content ────────────────────────────────
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlide,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _product.name,
                                      style: AppTextStyle.s24w7(),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppPallete.star,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_product.rating}',
                                          style: AppTextStyle.s12w5(
                                            color: AppPallete.bodyText,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${_product.reviewCount})',
                                          style: AppTextStyle.s12w4(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '\$${_product.price.toStringAsFixed(2)}',
                                          style: AppTextStyle.s24w7(
                                            color: AppPallete.bodyText,
                                          ),
                                        ),
                                        if (_product.originalPrice != null) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            '\$${_product.originalPrice!.toStringAsFixed(2)}',
                                            style: AppTextStyle.strikethrough(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              QuantityCounter(
                                quantity: _quantity,
                                onIncrement: () => setState(() => _quantity++),
                                onDecrement: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),
                          Divider(color: AppPallete.stroke, height: 1),
                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Size Guide', style: AppTextStyle.s14w6()),
                              GestureDetector(
                                onTap: _showSizeGuide,
                                child: Text(
                                  'Guide →',
                                  style: AppTextStyle.s12w5(
                                    color: AppPallete.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          SizeSelector(
                            sizes: _sizes,
                            selectedSize: _selectedSize,
                            onSelected: (s) =>
                                setState(() => _selectedSize = s),
                          ),

                          const SizedBox(height: 22),
                          Text('Description', style: AppTextStyle.s14w6()),
                          const SizedBox(height: 8),

                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 280),
                            crossFadeState: _descExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product.description,
                                  style: AppTextStyle.s12w4(
                                    color: AppPallete.subTextColor,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _descExpanded = true),
                                  child: Text(
                                    'See more......',
                                    style: AppTextStyle.s12w5(
                                      color: AppPallete.bodyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            secondChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product.description,
                                  style: AppTextStyle.s12w4(
                                    color: AppPallete.subTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _descExpanded = false),
                                  child: Text(
                                    'See less',
                                    style: AppTextStyle.s12w5(
                                      color: AppPallete.bodyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom CTA bar ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomCtaBar(
              addToCartKey: _addToCartBtnKey,
              buyNowKey: _buyNowBtnKey,
              cartBtnState: _cartBtnState,
              btnTextFade: _btnTextFade,
              addedFade: _addedFade,
              shakeOffset: _shakeOffset,
              onAddToCart: _handleAddToCart,
              onBuyNow: _handleBuyNow,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Bottom CTA bar — unchanged
// ─────────────────────────────────────────────────────────
class _BottomCtaBar extends StatelessWidget {
  final GlobalKey addToCartKey;
  final GlobalKey buyNowKey;
  final _CartBtnState cartBtnState;
  final Animation<double> btnTextFade;
  final Animation<double> addedFade;
  final Animation<double> shakeOffset;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _BottomCtaBar({
    required this.addToCartKey,
    required this.buyNowKey,
    required this.cartBtnState,
    required this.btnTextFade,
    required this.addedFade,
    required this.shakeOffset,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
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
          // ── Add to Cart ─────────────────────────────
          Expanded(
            child: SizedBox(
              key: addToCartKey,
              height: 52,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: OutlinedButton(
                  onPressed: onAddToCart,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: cartBtnState == _CartBtnState.added
                        ? AppPallete.primary.withValues(alpha: 0.06)
                        : AppPallete.surface,
                    side: BorderSide(
                      color: cartBtnState == _CartBtnState.added
                          ? AppPallete.primary
                          : AppPallete.border,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _buildCartBtnContent(
                    cartBtnState,
                    btnTextFade,
                    addedFade,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Buy Now ─────────────────────────────────
          Expanded(
            child: SizedBox(
              key: buyNowKey,
              height: 52,
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.bodyText,
                  foregroundColor: AppPallete.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: AnimatedBuilder(
                  animation: shakeOffset,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(shakeOffset.value, 0),
                    child: child,
                  ),
                  child: Row(
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
    );
  }

  Widget _buildCartBtnContent(
    _CartBtnState state,
    Animation<double> textFade,
    Animation<double> addedFade,
  ) {
    switch (state) {
      case _CartBtnState.idle:
        return FadeTransition(
          key: const ValueKey('idle'),
          opacity: textFade,
          child: Text(
            'Add to Cart',
            style: AppTextStyle.button(color: AppPallete.bodyText),
          ),
        );
      case _CartBtnState.flying:
        return const Icon(
          key: ValueKey('flying'),
          Icons.shopping_bag_outlined,
          color: AppPallete.primary,
          size: 22,
        );
      case _CartBtnState.added:
        return FadeTransition(
          key: const ValueKey('added'),
          opacity: addedFade,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
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

// ─────────────────────────────────────────────────────────
//  AppBar circle icon button — unchanged
// ─────────────────────────────────────────────────────────
class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _AppBarIconBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppPallete.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? AppPallete.bodyText, size: 20),
      ),
    );
  }
}
